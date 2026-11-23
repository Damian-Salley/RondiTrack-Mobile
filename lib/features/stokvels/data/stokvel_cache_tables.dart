import 'package:drift/drift.dart';

class StokvelSnapshots extends Table {
  IntColumn get stokvelId => integer()();

  // Zero identifies the default detail route. The actual cycle is resolved by
  // the server. Historical cycle links use their own cache records.
  IntColumn get requestedCycleId => integer()();
  IntColumn get cachedCycleId => integer().nullable()();
  TextColumn get detail => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {stokvelId, requestedCycleId};
}

class CachedCycles extends Table {
  IntColumn get id => integer()();
  TextColumn get status => text()();
  IntColumn get number => integer()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get targetCents => integer()();
  IntColumn get requiredCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
