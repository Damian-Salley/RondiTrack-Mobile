import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/home/data/api_home_repository.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/home/domain/home_repository.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

part 'home_providers.g.dart';

/// Provides the Home repository used to retrieve stokvel information.
@riverpod
HomeRepository homeRepository(Ref ref) {
  if (ref.watch(useApiProvider)) {
    ref.watch(authProvider);
    return ApiHomeRepository(ref.watch(apiClientProvider));
  }
  return FakeHomeRepository(ref.watch(sessionProvider));
}
