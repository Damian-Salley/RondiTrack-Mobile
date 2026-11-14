import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/auth_redirect.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

void main() {
  test('gate covers signed out, signed in, invite and sign-in', () {
    expect(authRedirect(null, Uri.parse('/sign-in')), isNull);
    expect(
      authRedirect(null, Uri.parse('/join/family')),
      '/sign-in?from=%2Fjoin%2Ffamily',
    );
    expect(authRedirect(Persona.demo, Uri.parse('/stokvels/1')), isNull);
    expect(
      authRedirect(Persona.demo, Uri.parse('/sign-in?from=%2Fjoin%2Ffamily')),
      '/join/family',
    );
    expect(authRedirect(Persona.demo, Uri.parse('/sign-in')), '/home');
    expect(
      authRedirect(null, Uri.parse('/stokvels/1/cycles/101')),
      '/sign-in?from=%2Fstokvels%2F1%2Fcycles%2F101',
    );
  });

  test('only safe internal destinations survive the gate', () {
    expect(
      authRedirect(null, Uri.parse('ronditrack-dev://app/join/family')),
      '/sign-in?from=%2Fjoin%2Ffamily',
    );
    for (final address in [
      null,
      '',
      'https://evil.example/join/x',
      '//evil.example',
      '/sign-in',
      '/join/x?from=https://evil.example',
      '/join/%2f%2fevil',
      '/home#x',
      r'/\evil',
      '/unknown',
    ]) {
      expect(safeDestination(address), '/home', reason: address);
    }
    expect(safeDestination('/stokvels/1/cycles/101'), '/stokvels/1/cycles/101');
  });

  for (final (persona, address, message) in [
    (
      Persona.newcomer,
      const StokvelRoute(id: '1').location,
      'Stokvel not found.',
    ),
    (
      Persona.demo,
      const StokvelRoute(id: '999').location,
      'Stokvel not found.',
    ),
    (
      Persona.demo,
      const StokvelRoute(id: 'bad').location,
      'Stokvel not found.',
    ),
    (
      Persona.newcomer,
      const CycleRoute(id: '1', cycleId: '101').location,
      'Cycle not found.',
    ),
    (
      Persona.demo,
      const CycleRoute(id: '1', cycleId: '201').location,
      'Cycle not found.',
    ),
    (
      Persona.demo,
      const CycleRoute(id: '1', cycleId: '999').location,
      'Cycle not found.',
    ),
    (
      Persona.demo,
      const CycleRoute(id: '1', cycleId: 'bad').location,
      'Cycle not found.',
    ),
  ]) {
    testWidgets('$persona at $address returns $message', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(persona.email);
      container.read(routerProvider).go(address);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const RondiTrackApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
      expect(find.textContaining("don't have access"), findsNothing);
      expect(find.text('Contributions'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'same persona has treasurer actions only in its treasurer stokvel',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(Persona.demo.email);
      final router = container.read(routerProvider)
        ..go(const StokvelRoute(id: '1').location);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const RondiTrackApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Close cycle'), 200);
      expect(find.text('Confirm contributions'), findsOneWidget);
      expect(find.text('Close cycle'), findsOneWidget);
      router.go(const StokvelRoute(id: '2').location);
      await tester.pumpAndSettle();
      expect(find.text('Your role: Member'), findsOneWidget);
      expect(find.text('Confirm contributions'), findsNothing);
      expect(find.text('Close cycle'), findsNothing);
      expect(find.text('Record payout'), findsNothing);
    },
  );

  testWidgets(
    'signed-out invite survives email sign-in and sign-out clears back',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final router = container.read(routerProvider)
        ..go(const JoinRoute(code: 'family').location);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const RondiTrackApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sign in'), findsNWidgets(2));
      await tester.enterText(find.byType(TextField), Persona.demo.email);
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Invite code: family'), findsOneWidget);
      await tester.tap(find.text('Join'));
      await tester.pumpAndSettle();
      router.go(const ProfileRoute().location);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(router.canPop(), isFalse);
      expect(container.read(authProvider), isNull);
    },
  );

  testWidgets('cycle branch keeps its stack and scroll across tabs', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(authProvider.notifier).signIn(Persona.demo.email);
    final router = container.read(routerProvider)
      ..go(const CycleRoute(id: '1', cycleId: '101').location);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const RondiTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -180));
    await tester.pumpAndSettle();
    final scroll = tester
        .state<ScrollableState>(find.byType(Scrollable).last)
        .position
        .pixels;
    await tester.tap(find.text('Activity').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stokvels').last);
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      '/stokvels/1/cycles/101',
    );
    expect(
      tester
          .state<ScrollableState>(find.byType(Scrollable).last)
          .position
          .pixels,
      scroll,
    );
    router.pop();
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/stokvels/1');
    router.pop();
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/stokvels');
  });
}
