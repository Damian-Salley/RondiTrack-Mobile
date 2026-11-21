import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/close_preview.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/stokvel_repository.dart';

part 'stokvel_providers.g.dart';

final joinInviteProvider = Provider<Future<int> Function(String)>((ref) {
  if (!ref.watch(useApiProvider)) return (_) async => 1;
  return ref.watch(apiClientProvider).join;
});

// The router keeps this active so a route change cannot repeat a join.
final joinAttemptsProvider = Provider<Map<String, Future<int>>>((ref) {
  ref.watch(authProvider);
  final attempts = <String, Future<int>>{};
  ref.onDispose(attempts.clear);
  return attempts;
});

/// Provides the repository used to retrieve stokvel details.
@riverpod
StokvelRepository stokvelRepository(Ref ref) {
  if (ref.watch(useApiProvider)) {
    ref.watch(authProvider);
    return ApiStokvelRepository(
      ref.watch(apiClientProvider),
      ref.watch(homeRepositoryProvider),
    );
  }
  return FakeStokvelRepository(ref.watch(sessionProvider));
}

@riverpod
Future<StokvelDetail?> cycleDetail(Ref ref, int stokvelId, int cycleId) {
  final repository = ref.watch(stokvelRepositoryProvider);
  if (repository is ApiStokvelRepository) {
    return repository.fetchDetail(stokvelId, cycleId: cycleId);
  }
  return repository.fetchDetail(stokvelId);
}

@riverpod
Future<CycleClosePreview> cycleClosePreview(
  Ref ref,
  int stokvelId,
  int cycleId,
) {
  final repository = ref.watch(stokvelRepositoryProvider);
  if (repository is ApiStokvelRepository) {
    return repository.previewClose(stokvelId, cycleId);
  }
  throw UnsupportedError('Close preview requires the API.');
}
