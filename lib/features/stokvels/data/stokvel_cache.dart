import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ronditrack_mobile/core/cached_value.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

typedef StokvelCacheKey = ({int stokvelId, int? cycleId});

class StokvelCache {
  const new(this._db);

  final OfflineDatabase _db;

  Stream<CachedValue<StokvelDetail>?> watch(StokvelCacheKey key) {
    final details = _db.stokvelSnapshots;
    final cycles = _db.cachedCycles;
    final query =
        _db.select(details).join([
          leftOuterJoin(cycles, cycles.id.equalsExp(details.cachedCycleId)),
        ])..where(
          details.stokvelId.equals(key.stokvelId) &
              details.requestedCycleId.equals(key.cycleId ?? 0),
        );
    return query.watchSingleOrNull().map((result) {
      if (result == null) return null;
      final detail = result.readTable(details);
      return (
        data: _decode(detail, result.readTableOrNull(cycles)),
        updatedAt: detail.updatedAt.toUtc(),
      );
    });
  }

  Future<void> save(
    StokvelCacheKey key,
    StokvelDetail detail,
    DateTime time,
    int generation,
  ) => _db.writeFor(generation, () async {
    if (detail.currentCycle case final cycle?) {
      await _db
          .into(_db.cachedCycles)
          .insertOnConflictUpdate(
            CachedCycle(
              id: cycle.id,
              status: cycle.status.name,
              number: cycle.number,
              dueDate: cycle.dueDateUtc,
              targetCents: cycle.targetAmount.value,
              requiredCents: cycle.requiredContribution.value,
            ),
          );
    }
    final snapshot = StokvelSnapshot(
      stokvelId: key.stokvelId,
      requestedCycleId: key.cycleId ?? 0,
      cachedCycleId: detail.currentCycle?.id,
      detail: jsonEncode(_encode(detail)),
      updatedAt: time,
    );
    await _db.into(_db.stokvelSnapshots).insertOnConflictUpdate(snapshot);
    if (snapshot.cachedCycleId case final int cycleId
        when key.cycleId == null) {
      await _db
          .into(_db.stokvelSnapshots)
          .insertOnConflictUpdate(snapshot.copyWith(requestedCycleId: cycleId));
    }
    await _removeUnusedCycles();
  });

  Future<void> remove(StokvelCacheKey key, int generation) =>
      _db.writeFor(generation, () async {
        final delete = _db.delete(_db.stokvelSnapshots)
          ..where(
            (row) =>
                row.stokvelId.equals(key.stokvelId) &
                row.requestedCycleId.equalsNullable(key.cycleId),
          );
        if (key.cycleId == null) {
          // A missing stokvel invalidates its historical detail records too.
          await (_db.delete(
            _db.stokvelSnapshots,
          )..where((row) => row.stokvelId.equals(key.stokvelId))).go();
        } else {
          await delete.go();
        }
        await _removeUnusedCycles();
      });

  Future<void> _removeUnusedCycles() => _db.customUpdate(
    'DELETE FROM cached_cycles WHERE id NOT IN '
    '(SELECT cached_cycle_id FROM stokvel_snapshots '
    'WHERE cached_cycle_id IS NOT NULL)',
    updates: {_db.cachedCycles},
  );

  static Map<String, Object?> _encode(StokvelDetail detail) => {
    'name': detail.stokvel.name,
    'amount': detail.stokvel.contributionAmount.value,
    'members': detail.stokvel.memberCount,
    'version': detail.stokvel.version,
    'role': detail.membership.role.name,
    'caller': detail.callerId,
    'contributions': [
      for (final row in detail.contributions)
        {
          'member': row.userId,
          'name': row.memberName,
          'cycle': row.cycleId,
          'amount': row.amount.value,
          'status': row.status.name,
          'paidAt': row.paidAtUtc?.toIso8601String(),
        },
    ],
  };

  static StokvelDetail _decode(StokvelSnapshot snapshot, CachedCycle? cycle) {
    final row = jsonDecode(snapshot.detail) as Map<String, Object?>;
    final id = snapshot.stokvelId;
    final rows = (row['contributions']! as List<Object?>)
        .cast<Map<String, Object?>>();
    return StokvelDetail(
      stokvel: Stokvel(
        id: id,
        name: row['name']! as String,
        contributionAmount: Cents(row['amount']! as int),
        memberCount: row['members']! as int,
        version: row['version'] as String?,
      ),
      membership: Membership(
        stokvelId: id,
        role: StokvelRole.values.byName(row['role']! as String),
      ),
      callerId: row['caller']! as int,
      currentCycle: cycle == null
          ? null
          : Cycle(
              id: cycle.id,
              stokvelId: id,
              number: cycle.number,
              status: CycleStatus.values.byName(cycle.status),
              dueDateUtc: cycle.dueDate.toUtc(),
              targetAmount: Cents(cycle.targetCents),
              requiredContribution: Cents(cycle.requiredCents),
            ),
      contributions: [
        for (final item in rows)
          Contribution(
            userId: item['member']! as int,
            stokvelId: id,
            cycleId: item['cycle']! as int,
            memberName: item['name']! as String,
            amount: Cents(item['amount']! as int),
            status: ContributionStatus.values.byName(item['status']! as String),
            paidAtUtc: DateTime.tryParse(item['paidAt'] as String? ?? ''),
          ),
      ],
    );
  }
}
