import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

import 'support/repositories.dart';

void main() {
  // Check that refreshing keeps existing data, but switching personas does not.
  test(
    'view conversion retains manual refresh data but hides a new persona',
    () async {
      final entries = await const FakeHomeRepository(
        Persona.demo,
        delay: Duration.zero,
      ).fetchHome();

      final pending = Completer<List<HomeEntry>>();
      var calls = 0;

      final repo = TestHomeRepository(
        () async => ++calls == 1 ? entries : await pending.future,
      );

      final container = ProviderContainer(
        retry: (retryCount, error) => null,
        overrides: [homeRepositoryProvider.overrideWithValue(repo)],
      );

      addTearDown(container.dispose);

      final listener = container.listen(homeProvider, (_, _) {});
      addTearDown(listener.close);

      await container.read(homeProvider.future);
      container.invalidate(homeProvider);

      final refreshing = toViewState(
        container.read(homeProvider),
        isEmpty: (items) => items.isEmpty,
      ) as Data<List<HomeEntry>>;

      expect(refreshing.value, entries);
      expect(refreshing.refreshing, isTrue);

      pending.complete(entries);
      await container.read(homeProvider.future);

      // Use the real provider dependencies to test persona switching.
      final sessions = ProviderContainer(retry: (retryCount, error) => null);

      addTearDown(sessions.dispose);

      final home = sessions.listen(homeProvider, (_, _) {});
      addTearDown(home.close);

      await sessions.read(homeProvider.future);

      sessions.read(sessionProvider.notifier).select(Persona.newcomer);

      expect(
        toViewState(
          sessions.read(homeProvider),
          isEmpty: (items) => items.isEmpty,
        ),
        isA<Loading<List<HomeEntry>>>(),
      );

      expect(await sessions.read(homeProvider.future), isEmpty);
    },
  );

  // Check that different stokvel IDs have separate data and shared listeners.
  test('two IDs remain separate; two listeners share one fetch', () async {
    final slow = Completer<StokvelDetail?>();

    const fake = FakeStokvelRepository(Persona.demo, delay: Duration.zero);

    final repo = TestStokvelRepository(
      (id) => id == 2 ? slow.future : fake.fetchDetail(id),
    );

    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [stokvelRepositoryProvider.overrideWithValue(repo)],
    );

    addTearDown(container.dispose);

    final first = container.listen(detailProvider(1), (_, _) {});
    final second = container.listen(detailProvider(1), (_, _) {});
    final other = container.listen(detailProvider(2), (_, _) {});

    addTearDown(first.close);
    addTearDown(second.close);
    addTearDown(other.close);

    expect((await container.read(detailProvider(1).future))!.stokvel.id, 1);
    expect(container.read(detailProvider(2)).isLoading, isTrue);
    expect(repo.calls, {1: 1, 2: 1});

    slow.complete(await fake.fetchDetail(2));

    expect((await container.read(detailProvider(2).future))!.stokvel.id, 2);
    expect(container.read(detailProvider(1)).requireValue!.stokvel.id, 1);
  });

  // Check that a provider is disposed after its last listener closes.
  test('detail is disposed only after its final listener closes', () async {
    final repo = TestStokvelRepository(
      const FakeStokvelRepository(
        Persona.demo,
        delay: Duration.zero,
      ).fetchDetail,
    );

    final container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [stokvelRepositoryProvider.overrideWithValue(repo)],
    );

    addTearDown(container.dispose);

    final first = container.listen(detailProvider(1), (_, _) {});
    final second = container.listen(detailProvider(1), (_, _) {});

    await container.read(detailProvider(1).future);

    first.close();
    await container.pump();

    expect(container.exists(detailProvider(1)), isTrue);

    second.close();
    await container.pump();

    expect(container.exists(detailProvider(1)), isFalse);

    final again = container.listen(detailProvider(1), (_, _) {});
    addTearDown(again.close);

    await container.read(detailProvider(1).future);

    expect(repo.calls[1], 2);
  });
}
