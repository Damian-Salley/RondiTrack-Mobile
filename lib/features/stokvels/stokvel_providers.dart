import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/close_preview.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/stokvel_repository.dart';

part 'stokvel_providers.g.dart';

/// Provides the repository used to retrieve stokvel details.
@riverpod
StokvelRepository stokvelRepository(Ref ref) {
  final persona = ref.watch(sessionProvider);
  return ref.watch(useApiProvider)
      ? ApiStokvelRepository(
          ref.watch(apiClientProvider),
          ref.watch(homeRepositoryProvider),
        )
      : FakeStokvelRepository(persona);
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
