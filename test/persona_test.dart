import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/features/payouts/presentation/payout_provider.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

import 'support/repositories.dart';

Future<void> pumpApp(WidgetTester tester, ProviderContainer container) =>
    tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const RondiTrackApp(),
      ),
    );

void main() {
  for (final flavor in ['staging', 'prod']) {
    testWidgets('twist: $flavor config constructs no switcher or dev route', (
      tester,
    ) async {
      final container = ProviderContainer(
        retry: appRetry,
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig.validate(
              flavor: flavor,
              nativeFlavor: flavor,
              refreshCookieName: 'testSession',
              apiBaseUrl: 'https://localhost',
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(Persona.demo.email);
      final router = container.read(routerProvider)..go('/profile');
      await pumpApp(tester, container);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('persona-switcher')), findsNothing);
      expect(find.byType(PopupMenuButton<Persona>), findsNothing);
      router.go('/dev/personas');
      await tester.pumpAndSettle();
      expect(find.text('Page not found.'), findsOneWidget);
      await container.read(authProvider.notifier).signOut();
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byKey(const Key('persona-switcher')), findsNothing);
      expect(find.byType(PopupMenuButton<Persona>), findsNothing);
    });
  }

  for (final persona in Persona.values) {
    testWidgets('twist: Home table for ${persona.label}', (tester) async {
      final container = ProviderContainer(retry: appRetry);
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(persona.email);
      await pumpApp(tester, container);
      await tester.pumpAndSettle();
      if (persona == Persona.newcomer) {
        expect(
          find.text('No stokvels yet. Ask a stokvel organiser for an invite.'),
          findsOneWidget,
        );
        expect(find.text('Community Savings'), findsNothing);
      } else {
        expect(find.text('Community Savings'), findsOneWidget);
        expect(find.text('Mabena Family'), findsOneWidget);
        expect(
          find.text('Your role: Treasurer'),
          persona == Persona.demo ? findsOneWidget : findsNothing,
        );
        expect(
          find.text('Your role: Member'),
          persona == Persona.demo ? findsOneWidget : findsNWidgets(2),
        );
        expect(
          find.text(
            persona == Persona.demo
                ? 'Paid: R\u00a0250,00'
                : 'Paid: R\u00a00,10',
          ),
          findsOneWidget,
        );
      }
    });

    for (final id in [1, 2]) {
      final cycleId = id == 1 ? '101' : '201';
      testWidgets('twist: stokvel $id table for ${persona.label}', (
        tester,
      ) async {
        final container = ProviderContainer(retry: appRetry);
        addTearDown(container.dispose);
        container.read(authProvider.notifier).signIn(persona.email);
        container.read(routerProvider).go(StokvelRoute(id: '$id').location);
        await pumpApp(tester, container);
        await tester.pumpAndSettle();
        if (persona == Persona.newcomer) {
          expect(find.text('Stokvel not found.'), findsOneWidget);
          expect(find.text('Contributions'), findsNothing);
        } else {
          final treasurer = persona == Persona.demo && id == 1;
          expect(
            find.text('Your role: ${treasurer ? 'Treasurer' : 'Member'}'),
            findsOneWidget,
          );
          // Inspect the action area even when it starts outside the viewport.
          await tester.scrollUntilVisible(find.text('Available actions'), 180);
          await tester.drag(find.byType(ListView).last, const Offset(0, -400));
          await tester.pumpAndSettle();
          expect(
            find.text('Record payout'),
            treasurer ? findsOneWidget : findsNothing,
          );
          expect(
            find.text('Close cycle'),
            treasurer ? findsOneWidget : findsNothing,
          );
        }
        expect(tester.takeException(), isNull);
      });

      testWidgets('twist: payouts $id table for ${persona.label}', (
        tester,
      ) async {
        final container = ProviderContainer(retry: appRetry);
        addTearDown(container.dispose);
        container.read(authProvider.notifier).signIn(persona.email);
        container
            .read(routerProvider)
            .go(PayoutsRoute(id: '$id', cycleId: cycleId).location);
        await pumpApp(tester, container);
        await tester.pumpAndSettle();
        if (persona == Persona.newcomer) {
          expect(find.text('Cycle not found.'), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
        } else if (id == 2) {
          expect(find.text('No payout order yet.'), findsOneWidget);
        } else {
          expect(find.text('1. Lerato'), findsOneWidget);
          expect(find.text('2. Sipho'), findsOneWidget);
          expect(find.text('Next to receive'), findsOneWidget);
        }
        expect(
          find.text('Record payout'),
          persona == Persona.demo && id == 1 ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final id in [1, 2]) {
    testWidgets('twist: switching with stokvel $id open clears the first frame '
        'and sign-out', (tester) async {
      final pending = Completer<StokvelDetail?>();
      final container = ProviderContainer(
        retry: appRetry,
        overrides: [
          stokvelRepositoryProvider.overrideWith((ref) {
            final persona = ref.watch(sessionProvider);
            return TestStokvelRepository(
              (id) => persona == Persona.contributor
                  ? pending.future
                  : FakeStokvelRepository(
                      persona,
                      delay: Duration.zero,
                    ).fetchDetail(id),
            );
          }),
        ],
      );
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(Persona.demo.email);
      final router = container.read(routerProvider)
        ..go(StokvelRoute(id: '$id').location);
      await pumpApp(tester, container);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('$id-1')), findsOneWidget);
      container.read(authProvider.notifier).signIn(Persona.contributor.email);
      await tester.pump();
      expect(container.read(authProvider), isA<SignedIn>());
      expect(find.byKey(ValueKey('$id-1')), findsNothing);
      expect(find.text('Your role: Treasurer'), findsNothing);
      expect(find.text('Record payout'), findsNothing);
      expect(find.bySemanticsLabel('Loading stokvel'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(ValueKey('$id-1')), findsNothing);
      pending.complete(
        await tester.runAsync<StokvelDetail?>(
          () => const FakeStokvelRepository(
            Persona.contributor,
            delay: Duration.zero,
          ).fetchDetail(id),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Your role: Member'), findsOneWidget);
      expect(find.text('Record payout'), findsNothing);
      await container.read(authProvider.notifier).signOut();
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
      expect(router.canPop(), isFalse);
      expect(find.byKey(ValueKey('$id-1')), findsNothing);
      container.read(authProvider.notifier).signIn(Persona.newcomer.email);
      await tester.pumpAndSettle();
      expect(find.text('Stokvel not found.'), findsOneWidget);
      router.go('/home');
      await tester.pumpAndSettle();
      expect(
        find.text('No stokvels yet. Ask a stokvel organiser for an invite.'),
        findsOneWidget,
      );
    });
  }

  testWidgets(
    'twist: open payouts hides old order on the first persona frame',
    (tester) async {
      final container = ProviderContainer(retry: appRetry);
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(Persona.demo.email);
      container
          .read(routerProvider)
          .go(const PayoutsRoute(id: '1', cycleId: '101').location);
      await pumpApp(tester, container);
      await tester.pumpAndSettle();
      expect(find.text('Record payout'), findsOneWidget);
      container.read(authProvider.notifier).signIn(Persona.contributor.email);
      await tester.pump();
      expect(find.text('1. Lerato'), findsNothing);
      expect(find.text('Record payout'), findsNothing);
      expect(find.bySemanticsLabel('Loading payouts'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Record payout'), findsNothing);
      // Signing out and back in must not restore a cached treasurer frame.
      await container.read(authProvider.notifier).signOut();
      await tester.pumpAndSettle();
      container.read(authProvider.notifier).signIn(Persona.newcomer.email);
      await tester.pump();
      expect(find.text('1. Lerato'), findsNothing);
      await tester.pumpAndSettle();
      expect(find.text('Cycle not found.'), findsOneWidget);
      expect(
        container.read(payoutsProvider((stokvelId: 1, cycleId: 101))).hasError,
        isTrue,
      );
    },
  );

  testWidgets('twist: failed new membership cannot retain old actions', (
    tester,
  ) async {
    final container = ProviderContainer(
      retry: appRetry,
      overrides: [
        stokvelRepositoryProvider.overrideWith((ref) {
          final persona = ref.watch(sessionProvider);
          return TestStokvelRepository(
            (id) => persona == Persona.demo
                ? const FakeStokvelRepository(
                    Persona.demo,
                    delay: Duration.zero,
                  ).fetchDetail(id)
                : Future<StokvelDetail?>.error(StateError('offline')),
          );
        }),
      ],
    );
    addTearDown(container.dispose);
    container.read(authProvider.notifier).signIn(Persona.demo.email);
    container
        .read(routerProvider)
        .go(const PayoutsRoute(id: '1', cycleId: '101').location);
    await pumpApp(tester, container);
    await tester.pumpAndSettle();
    expect(find.text('Record payout'), findsOneWidget);
    container.read(authProvider.notifier).signIn(Persona.contributor.email);
    await tester.pumpAndSettle();
    expect(find.text('1. Lerato'), findsOneWidget);
    expect(find.text('Record payout'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
