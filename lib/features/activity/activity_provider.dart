import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

final FutureProvider<List<Contribution>> activityProvider =
    FutureProvider.autoDispose<List<Contribution>>((ref) async {
      final home = ref.watch(homeRepositoryProvider);
      if (ref.watch(useApiProvider)) {
        return await fetchApiActivity(ref.watch(apiClientProvider));
      }
      final stokvels = ref.watch(stokvelRepositoryProvider);
      final entries = await home.fetchHome();
      final details = await Future.wait([
        for (final entry in entries)
          stokvels.fetchDetail(entry.membership.stokvelId),
      ]);
      return [for (final detail in details) ...?detail?.contributions];
    });
