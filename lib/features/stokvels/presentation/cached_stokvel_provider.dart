import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/cache_sync.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/offline_refresh.dart';
import 'package:ronditrack_mobile/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/data/stokvel_cache.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

final ProviderFamily<CacheSync<StokvelDetail>, StokvelCacheKey>
stokvelSyncProvider = Provider.autoDispose
    .family<CacheSync<StokvelDetail>, StokvelCacheKey>((ref, key) {
      final db = ref.watch(offlineDatabaseProvider);
      final generation = db.generation;
      final cache = StokvelCache(db);
      final repository = ref.watch(stokvelRepositoryProvider);
      final sync = CacheSync(
        cache: cache.watch(key),
        fetch: () async {
          final detail = repository is ApiStokvelRepository
              ? await repository.fetchDetail(
                  key.stokvelId,
                  cycleId: key.cycleId,
                )
              : await repository.fetchDetail(key.stokvelId);
          return detail ?? (throw const NotFoundFailure());
        },
        save: (data, time) => cache.save(key, data, time, generation),
        remove: () => cache.remove(key, generation),
        refreshes: ref
            .watch(offlineRefreshProvider)
            .stream
            .where((stokvel) => stokvel == key.stokvelId)
            .map((_) {}),
      );
      ref.onDispose(sync.dispose);
      return sync;
    });

final StreamProviderFamily<CacheState<StokvelDetail>, StokvelCacheKey>
cachedStokvelProvider = StreamProvider.autoDispose
    .family<CacheState<StokvelDetail>, StokvelCacheKey>(
      (ref, key) => ref.watch(stokvelSyncProvider(key)).states,
    );
