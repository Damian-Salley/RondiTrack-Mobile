import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_screen.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_screen.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

import 'support/repositories.dart';

void main() {
  // Test the Home screen's loading, empty, data, and error states.
  testWidgets('Home loading', (tester) async {
    final pending = Completer<List<HomeEntry>>();

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            TestHomeRepository(() => pending.future),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.bySemanticsLabel('Loading home'), findsOneWidget);
  });

  testWidgets('Home empty explains next step', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const FakeHomeRepository(Persona.newcomer, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('No stokvels yet. Ask a stokvel organiser for an invite.'),
      findsOneWidget,
    );
  });

  testWidgets('Home data uses server amounts and per-stokvel roles', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const FakeHomeRepository(Persona.demo, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Community Savings'), findsOneWidget);
    expect(find.text('Family Savings'), findsOneWidget);
    expect(find.text('Your role: Treasurer'), findsOneWidget);
    expect(find.text('Your role: Member'), findsOneWidget);
    expect(find.text('Paid: R\u00A0250,00'), findsOneWidget);
    expect(find.text('Next payout: Not scheduled'), findsNWidgets(2));
  });

  testWidgets('Home failure retries the overridden repository', (tester) async {
    var fail = true;

    final repo = TestHomeRepository(() async {
      if (fail) throw StateError('offline');

      return await const FakeHomeRepository(
        Persona.demo,
        delay: Duration.zero,
      ).fetchHome();
    });

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [homeRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Could not load your data. Please try again.'),
      findsOneWidget,
    );

    fail = false;

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Community Savings'), findsOneWidget);
    expect(repo.calls, 2);
  });

  testWidgets('pull to refresh retains old Home cards', (tester) async {
    final entries = (await tester.runAsync(
      () => const FakeHomeRepository(
        Persona.demo,
        delay: Duration.zero,
      ).fetchHome(),
    ))!;

    final pending = Completer<List<HomeEntry>>();
    var calls = 0;

    final repo = TestHomeRepository(
      () async => ++calls == 1 ? entries : await pending.future,
    );

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [homeRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(calls, 2);
    expect(find.text('Community Savings'), findsOneWidget);
    expect(find.text('Family Savings'), findsOneWidget);

    pending.complete(entries);

    await tester.pumpAndSettle();
  });

  // Test the stokvel detail screen and role-based actions.
  testWidgets('detail loading', (tester) async {
    final pending = Completer<StokvelDetail?>();

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            TestHomeRepository(() async => []),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            TestStokvelRepository((_) => pending.future),
          ),
        ],
        child: const MaterialApp(home: DetailScreen(stokvelId: 1)),
      ),
    );

    expect(find.bySemanticsLabel('Loading stokvel'), findsOneWidget);
  });

  testWidgets(
    'detail empty is not found for inaccessible and nonexistent IDs',
    (tester) async {
      for (final id in [1, 999]) {
        await tester.pumpWidget(
          ProviderScope(
            key: ValueKey(id),
            retry: (retryCount, error) => null,
            overrides: [
              homeRepositoryProvider.overrideWithValue(
                TestHomeRepository(() async => []),
              ),
              stokvelRepositoryProvider.overrideWithValue(
                const FakeStokvelRepository(
                  Persona.newcomer,
                  delay: Duration.zero,
                ),
              ),
            ],
            child: MaterialApp(home: DetailScreen(stokvelId: id)),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Stokvel not found.'), findsOneWidget);
        expect(find.textContaining("don't have access"), findsNothing);
      }
    },
  );

  testWidgets('detail data shows treasurer actions in that membership', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            TestHomeRepository(() async => []),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            const FakeStokvelRepository(Persona.demo, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(home: DetailScreen(stokvelId: 1)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Your role: Treasurer'), findsOneWidget);
    expect(find.text('Cycle 1: Open'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('Confirmed'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Close cycle'), 200);

    expect(find.text('Confirm contributions'), findsOneWidget);
    expect(find.text('Close cycle'), findsOneWidget);
    expect(find.text('Record payout'), findsOneWidget);
  });

  testWidgets(
    'treasurer detail hides confirmation when nobody has a paid row',
    (tester) async {
      final repository = TestStokvelRepository((id) async {
        final detail = await const FakeStokvelRepository(
          Persona.demo,
          delay: Duration.zero,
        ).fetchDetail(id);

        if (detail == null) return null;

        return detail.copyWith(
          contributions: [
            for (final contribution in detail.contributions)
              contribution.copyWith(status: .confirmed),
          ],
        );
      });

      await tester.pumpWidget(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              TestHomeRepository(() async => []),
            ),
            stokvelRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(home: DetailScreen(stokvelId: 1)),
        ),
      );

      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Close cycle'), 200);

      expect(find.text('Confirm contributions'), findsNothing);
      expect(find.text('Close cycle'), findsOneWidget);
      expect(find.text('Record payout'), findsOneWidget);
    },
  );

  testWidgets('detail member has no treasurer actions', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            TestHomeRepository(() async => []),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            const FakeStokvelRepository(Persona.demo, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(home: DetailScreen(stokvelId: 2)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Your role: Member'), findsOneWidget);
    expect(find.text('Upload proof'), findsOneWidget);
    expect(find.text('Confirm contributions'), findsNothing);
    expect(find.text('Close cycle'), findsNothing);
    expect(find.text('Record payout'), findsNothing);
  });

  testWidgets('detail failure retry works', (tester) async {
    var fail = true;

    final repo = TestStokvelRepository((id) async {
      if (fail) throw StateError('offline');

      return await const FakeStokvelRepository(
        Persona.demo,
        delay: Duration.zero,
      ).fetchDetail(id);
    });

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            TestHomeRepository(() async => []),
          ),
          stokvelRepositoryProvider.overrideWithValue(repo),
        ],
        child: const MaterialApp(home: DetailScreen(stokvelId: 1)),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Could not load your data. Please try again.'),
      findsOneWidget,
    );

    fail = false;

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Your role: Treasurer'), findsOneWidget);
    expect(repo.calls[1], 2);
  });

  // Ensure switching stokvels never displays the previous stokvel's data.
  testWidgets(
    'switch to slow B shows B loading and no A contributions for a frame',
    (tester) async {
      const fake = FakeStokvelRepository(Persona.demo, delay: Duration.zero);
      final pending = Completer<StokvelDetail?>();

      final repo = TestStokvelRepository(
        (id) => id == 2 ? pending.future : fake.fetchDetail(id),
      );

      await tester.pumpWidget(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            homeRepositoryProvider.overrideWithValue(
              const FakeHomeRepository(Persona.demo, delay: Duration.zero),
            ),
            stokvelRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(home: DetailScreen(stokvelId: 1)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sample Contributor'), findsOneWidget);

      // Invoke the actual picker's callback, then render exactly one frame.
      tester
          .widget<DropdownButton<int>>(find.byKey(const Key('stokvel-picker')))
          .onChanged!(2);

      await tester.pump();

      expect(
        tester
            .widget<DropdownButton<int>>(
              find.byKey(const Key('stokvel-picker')),
            )
            .value,
        2,
      );

      expect(find.bySemanticsLabel('Loading stokvel'), findsOneWidget);
      expect(find.text('Sample Contributor'), findsNothing);
      expect(find.text('Demo Member'), findsNothing);
      expect(find.text('Your role: Treasurer'), findsNothing);
      expect(find.byKey(const ValueKey('1-1')), findsNothing);
      expect(find.byKey(const ValueKey('1-2')), findsNothing);

      pending.complete(
        await tester.runAsync<StokvelDetail?>(() => fake.fetchDetail(2)),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your role: Member'), findsOneWidget);
    },
  );
}
