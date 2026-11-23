import 'package:drift/drift.dart';

class HomeSnapshots extends Table {
  IntColumn get id => integer()();
  TextColumn get entries => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
