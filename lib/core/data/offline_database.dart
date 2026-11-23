import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox_table.dart';
import 'package:ronditrack_mobile/features/home/data/home_cache_table.dart';
import 'package:ronditrack_mobile/features/stokvels/data/stokvel_cache_tables.dart';

part 'offline_database.g.dart';

@DriftDatabase(
  tables: [HomeSnapshots, StokvelSnapshots, CachedCycles, PaymentOutbox],
)
class OfflineDatabase extends _$OfflineDatabase {
  new(super.e);

  @override
  int get schemaVersion => 1;

  int _generation = 0;

  int get generation => _generation;

  /// A response from a previous session cannot refill the deleted cache.
  Future<void> writeFor(int generation, Future<void> Function() write) =>
      transaction(() async {
        if (_generation == generation) await write();
      });

  Future<void> clearUserData() {
    _generation++;
    return transaction(() async {
      await delete(paymentOutbox).go();
      await delete(cachedCycles).go();
      await delete(stokvelSnapshots).go();
      await delete(homeSnapshots).go();
    });
  }
}

final offlineDatabaseProvider = Provider<OfflineDatabase>((ref) {
  final flavor = ref.watch(appConfigProvider).flavor;
  final database = OfflineDatabase(driftDatabase(name: 'ronditrack_$flavor'));
  ref.onDispose(database.close);
  return database;
});
