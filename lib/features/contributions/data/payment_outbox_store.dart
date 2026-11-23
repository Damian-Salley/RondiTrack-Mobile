import 'package:drift/drift.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox_table.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';

class PaymentOutboxStore {
  const new(this._db);

  final OfflineDatabase _db;

  int get generation => _db.generation;

  Stream<List<PaymentIntent>> watch() =>
      _ordered().watch().map((rows) => rows.map(_map).toList());

  Future<List<PaymentIntent>> read() async =>
      (await _ordered().get()).map(_map).toList();

  SimpleSelectStatement<PaymentOutbox, PaymentOutboxData> _ordered() =>
      _db.select(_db.paymentOutbox)
        ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]);

  Future<void> insert(PaymentIntent payment, int generation) =>
      _db.writeFor(generation, () async {
        await _db
            .into(_db.paymentOutbox)
            .insert(
              PaymentOutboxData(
                idempotencyKey: payment.key,
                stokvelId: payment.target.stokvelId,
                cycleId: payment.target.cycleId,
                userId: payment.target.userId,
                amountCents: payment.amount.value,
                createdAt: payment.createdAt,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      });

  Future<void> remove(String key, int generation) =>
      _db.writeFor(generation, () async {
        await (_db.delete(
          _db.paymentOutbox,
        )..where((row) => row.idempotencyKey.equals(key))).go();
      });

  Future<void> waitUntil(String key, DateTime retryAt, int generation) =>
      _db.writeFor(generation, () async {
        await (_db.update(_db.paymentOutbox)
              ..where((row) => row.idempotencyKey.equals(key)))
            .write(PaymentOutboxCompanion(retryAt: Value(retryAt)));
      });

  static PaymentIntent _map(PaymentOutboxData row) => PaymentIntent(
    key: row.idempotencyKey,
    target: (
      stokvelId: row.stokvelId,
      cycleId: row.cycleId,
      userId: row.userId,
    ),
    amount: Cents(row.amountCents),
    createdAt: row.createdAt.toUtc(),
    retryAt: row.retryAt?.toUtc(),
  );
}
