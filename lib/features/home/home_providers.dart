import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/home/domain/home_repository.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

part 'home_providers.g.dart';

/// Provides the Home repository used to retrieve stokvel information.
@riverpod
HomeRepository homeRepository(Ref ref) =>
    // Recreate the fake repository when the selected persona changes.
    FakeHomeRepository(ref.watch(sessionProvider));
