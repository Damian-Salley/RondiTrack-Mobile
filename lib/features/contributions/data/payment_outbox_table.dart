import 'package:drift/drift.dart';

class PaymentOutbox extends Table {
  TextColumn get idempotencyKey => text()();
  IntColumn get stokvelId => integer()();
  IntColumn get cycleId => integer()();
  IntColumn get userId => integer()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get retryAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {idempotencyKey};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {stokvelId, cycleId, userId},
  ];
}
