import 'dart:async';
import 'dart:math';

import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox_store.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';

class PaymentOutboxSync {
  new(
    this._store,
    this._send,
    this._refresh, {
    DateTime Function()? now,
    String Function()? newKey,
  }) : _now = now ?? DateTime.now,
       _newKey = newKey ?? _uuid;

  static const maximumAge = Duration(hours: 12);
  final PaymentOutboxStore _store;
  final Future<void> Function(PaymentIntent) _send;
  final void Function(int) _refresh;
  final DateTime Function() _now;
  final String Function() _newKey;
  final _events = StreamController<PaymentNotice>.broadcast();
  final _enqueuing = <PaymentTarget, Future<void>>{};
  Future<void>? _syncing;
  Timer? _timer;
  bool _disposed = false;

  Stream<PaymentNotice> get notices => _events.stream;

  Future<void> enqueue(PaymentTarget target, Cents amount) =>
      _enqueuing.putIfAbsent(target, () async {
        try {
          final generation = _store.generation;
          final existing = (await _store.read()).any((p) => p.target == target);
          if (!existing && !_disposed) {
            await _store.insert(
              PaymentIntent(
                key: _newKey(),
                target: target,
                amount: amount,
                createdAt: _now().toUtc(),
              ),
              generation,
            );
          }
          if (_syncing case final active?) await active;
          if (generation == _store.generation) await flush();
        } finally {
          unawaited(_enqueuing.remove(target));
        }
      });

  Future<void> flush() {
    if (_disposed) return Future.value();
    if (_syncing case final active?) return active;
    final operation = _flush(_store.generation);
    _syncing = operation;
    return operation.whenComplete(() => _syncing = null);
  }

  Future<void> _flush(int generation) async {
    _timer?.cancel();
    DateTime? nextRetry;
    for (final payment in await _store.read()) {
      if (!_current(generation)) return;
      final time = _now().toUtc();
      if (!time.isBefore(payment.createdAt.add(maximumAge))) {
        await _finish(payment, generation, PaymentDisposition.expired);
        continue;
      }
      if (payment.retryAt case final retryAt? when retryAt.isAfter(time)) {
        if (nextRetry == null || retryAt.isBefore(nextRetry)) {
          nextRetry = retryAt;
        }
        continue;
      }

      try {
        await _send(payment);
        await _finish(payment, generation, PaymentDisposition.paid);
        if (_current(generation)) _refresh(payment.target.stokvelId);
      } on RateLimitedFailure catch (error) {
        final wait = Duration(seconds: max(1, error.waitSeconds ?? 60));
        final retryAt = _now().toUtc().add(wait);
        await _store.waitUntil(payment.key, retryAt, generation);
        if (nextRetry == null || retryAt.isBefore(nextRetry)) {
          nextRetry = retryAt;
        }
        break;
      } on ApiFailure catch (error) {
        if (error is OfflineFailure ||
            error is ServerFailure ||
            error is UnauthorisedFailure) {
          break;
        }
        await _finish(payment, generation, PaymentDisposition.refused, error);
      }
    }
    if (nextRetry != null && _current(generation)) {
      _timer = Timer(nextRetry.difference(_now()), () => unawaited(flush()));
    }
  }

  bool _current(int generation) =>
      !_disposed && _store.generation == generation;

  Future<void> _finish(
    PaymentIntent payment,
    int generation,
    PaymentDisposition disposition, [
    ApiFailure? failure,
  ]) async {
    await _store.remove(payment.key, generation);
    if (_current(generation)) {
      _events.add((
        payment: payment,
        disposition: disposition,
        failure: failure,
      ));
    }
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    unawaited(_events.close());
  }

  static String _uuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
