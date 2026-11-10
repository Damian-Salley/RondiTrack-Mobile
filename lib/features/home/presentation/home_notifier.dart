import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';

part 'home_notifier.g.dart';

/// Manages asynchronous Home screen data using Riverpod.
@riverpod
class Home extends _$Home {
  // Fetch Home data from the repository.
  // Riverpod automatically reloads it when the repository changes.
  @override
  Future<List<HomeEntry>> build() =>
      ref.watch(homeRepositoryProvider).fetchHome();
}
