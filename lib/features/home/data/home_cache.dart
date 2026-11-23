import 'dart:convert';

import 'package:ronditrack_mobile/core/cached_value.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

class HomeCache {
  const new(this._db);

  final OfflineDatabase _db;

  Stream<CachedValue<List<HomeEntry>>?> watch() =>
      (_db.select(
        _db.homeSnapshots,
      )..where((row) => row.id.equals(1))).watchSingleOrNull().map((snapshot) {
        if (snapshot == null) return null;
        final rows = (jsonDecode(snapshot.entries) as List<Object?>)
            .cast<Map<String, Object?>>();
        return (
          data: rows.map(_decode).toList(growable: false),
          updatedAt: snapshot.updatedAt.toUtc(),
        );
      });

  Future<void> save(List<HomeEntry> entries, DateTime time, int generation) =>
      _db.writeFor(generation, () async {
        await _db
            .into(_db.homeSnapshots)
            .insertOnConflictUpdate(
              HomeSnapshot(
                id: 1,
                entries: jsonEncode(entries.map(_encode).toList()),
                updatedAt: time,
              ),
            );
      });

  static Map<String, Object?> _encode(HomeEntry entry) => {
    'id': entry.membership.stokvelId,
    'role': entry.membership.role.name,
    'name': entry.stokvelName,
    'paid': entry.paidThisCycle.value,
    'owed': entry.stillOwes.value,
    'arrears': entry.arrears.value,
    'collected': entry.totalCollected.value,
    'cycle': entry.currentCycle,
    'cycleStatus': entry.cycleStatus?.name,
    'nextPayout': entry.nextPayoutDate?.toIso8601String(),
  };

  static HomeEntry _decode(Map<String, Object?> row) => HomeEntry(
    membership: Membership(
      stokvelId: row['id']! as int,
      role: StokvelRole.values.byName(row['role']! as String),
    ),
    stokvelName: row['name']! as String,
    paidThisCycle: Cents(row['paid']! as int),
    stillOwes: Cents(row['owed']! as int),
    arrears: Cents(row['arrears']! as int),
    totalCollected: Cents(row['collected']! as int),
    currentCycle: row['cycle'] as int?,
    cycleStatus: switch (row['cycleStatus']) {
      final String value => CycleStatus.values.byName(value),
      _ => null,
    },
    nextPayoutDate: DateTime.tryParse(row['nextPayout'] as String? ?? ''),
  );
}
