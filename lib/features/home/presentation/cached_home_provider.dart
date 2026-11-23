import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/cache_sync.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/offline_refresh.dart';
import 'package:ronditrack_mobile/features/home/data/home_cache.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';

final Provider<CacheSync<List<HomeEntry>>> homeSyncProvider =
    Provider.autoDispose<CacheSync<List<HomeEntry>>>((ref) {
      final db = ref.watch(offlineDatabaseProvider);
      final generation = db.generation;
      final cache = HomeCache(db);
      final repository = ref.watch(homeRepositoryProvider);
      final sync = CacheSync(
        cache: cache.watch(),
        fetch: repository.fetchHome,
        save: (data, time) => cache.save(data, time, generation),
        remove: () async {},
        refreshes: ref.watch(offlineRefreshProvider).stream.map((_) {}),
      );
      ref.onDispose(sync.dispose);
      return sync;
    });

final StreamProvider<CacheState<List<HomeEntry>>> cachedHomeProvider =
    StreamProvider.autoDispose<CacheState<List<HomeEntry>>>(
      (ref) => ref.watch(homeSyncProvider).states,
    );
