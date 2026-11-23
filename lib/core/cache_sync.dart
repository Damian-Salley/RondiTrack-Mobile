import 'dart:async';

import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/cached_value.dart';

typedef CacheState<T> = ({
  CachedValue<T>? cached,
  bool refreshing,
  ApiFailure? failure,
});

class CacheSync<T> {
  new({
    required Stream<CachedValue<T>?> cache,
    required this._fetch,
    required this._save,
    required this._remove,
    required Stream<void> refreshes,
  }) {
    _cache = cache.listen(
      (value) {
        _publish((
          cached: value,
          refreshing: _state.refreshing,
          failure: _state.failure,
        ));
        if (!_started) {
          _started = true;
          unawaited(refresh());
        }
      },
      onError: (Object _) => _publish((
        cached: _state.cached,
        refreshing: false,
        failure: const ServerFailure(null),
      )),
    );
    _refreshes = refreshes.listen((_) {
      if (_active != null) {
        _refreshQueued = true;
      } else {
        unawaited(refresh());
      }
    });
  }

  final Future<T> Function() _fetch;
  final Future<void> Function(T, DateTime) _save;
  final Future<void> Function() _remove;
  final _changes = StreamController<CacheState<T>>.broadcast();
  late final StreamSubscription<CachedValue<T>?> _cache;
  late final StreamSubscription<void> _refreshes;
  CacheState<T> _state = (cached: null, refreshing: true, failure: null);
  Future<void>? _active;
  bool _started = false;
  bool _disposed = false;
  bool _refreshQueued = false;

  Stream<CacheState<T>> get states => Stream.multi((listener) {
    final subscription = _changes.stream.listen(
      listener.add,
      onDone: listener.close,
    );
    listener
      ..add(_state)
      ..onCancel = subscription.cancel;
  });

  Future<void> refresh() {
    if (_disposed) return Future.value();
    if (_active case final active?) return active;
    final operation = _refresh();
    _active = operation;
    return operation.whenComplete(() {
      _active = null;
      if (_refreshQueued) {
        _refreshQueued = false;
        unawaited(refresh());
      }
    });
  }

  Future<void> _refresh() async {
    _publish((
      cached: _state.cached,
      refreshing: true,
      failure: _state.failure,
    ));
    ApiFailure? failure;
    try {
      final data = await _fetch();
      if (!_disposed) await _save(data, DateTime.now().toUtc());
    } on NotFoundFailure catch (error) {
      if (!_disposed) await _remove();
      _publish((cached: null, refreshing: false, failure: error));
      return;
    } on ApiFailure catch (error) {
      failure = error;
    } on Object {
      failure = const ServerFailure(null);
    }
    _publish((cached: _state.cached, refreshing: false, failure: failure));
  }

  void _publish(CacheState<T> state) {
    if (_disposed) return;
    _state = state;
    _changes.add(state);
  }

  void dispose() {
    _disposed = true;
    unawaited(_cache.cancel());
    unawaited(_refreshes.cancel());
    unawaited(_changes.close());
  }
}
