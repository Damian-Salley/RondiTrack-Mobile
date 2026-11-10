import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/stokvel_repository.dart';

part 'stokvel_providers.g.dart';

/// Provides the repository used to retrieve stokvel details.
@riverpod
StokvelRepository stokvelRepository(Ref ref) =>
    // Recreate the repository when the selected persona changes.
    FakeStokvelRepository(ref.watch(sessionProvider));
