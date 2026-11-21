import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/auth_redirect.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

import 'support/session_fixture.dart';

void main() {
  Persona persona(Ref ref) => switch (ref.watch(authProvider)) {
    SignedIn(:final label) when label == Persona.demo.email => Persona.demo,
    _ => Persona.newcomer,
  };

  SessionFixture fixture({String? stored, Future<int> Function(String)? join}) {
    final fixture = SessionFixture(
      stored: stored,
      overrides: [
        homeRepositoryProvider.overrideWith(
          (ref) => FakeHomeRepository(persona(ref), delay: Duration.zero),
        ),
        stokvelRepositoryProvider.overrideWith(
          (ref) => FakeStokvelRepository(persona(ref), delay: Duration.zero),
        ),
        if (join != null) joinInviteProvider.overrideWithValue(join),
      ],
    );
    addTearDown(fixture.dispose);
    return fixture;
  }

  Future<void> launch(
    WidgetTester tester,
    SessionFixture fixture, [
    String address = '/home',
  ]) => tester.pumpWidget(
    UncontrolledProviderScope(
      container: fixture.container..read(routerProvider).go(address),
      child: const RondiTrackApp(),
    ),
  );

  Future<void> type(WidgetTester tester, String label, String value) =>
      tester.enterText(find.widgetWithText(TextField, label), value);

  Future<void> signIn(WidgetTester tester, Persona persona) async {
    await type(tester, 'Email', persona.email);
    await type(tester, 'Password', sampleInput);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
  }

  test(
    'restoring directs every protected route to splash with its destination',
    () {
      for (final path in [
        '/home',
        '/profile',
        '/join/FAMILY',
        '/stokvels/1/cycles/101/payouts',
        '/activity',
        '/stokvels',
      ]) {
        final splash = Uri.parse(
          authRedirect(const Restoring(), Uri.parse(path))!,
        );
        expect(splash.path, '/restore');
        expect(splash.queryParameters['from'], path);
        expect(authRedirect(const SignedIn('Lerato'), splash), path);
        expect(
          Uri.parse(authRedirect(const SignedOut(), splash)!)
              .queryParameters['from'],
          path,
        );
      }
    },
  );

  testWidgets('offline splash preserves the invite and supports retry', (
    tester,
  ) async {
    var joins = 0;
    final session =
        fixture(
            stored: 'saved',
            join: (code) async {
              expect(code, 'FAMILY');
              joins++;
              return 1;
            },
          )
          ..offline = true
          ..refreshToken = 'saved';
    await launch(tester, session, '/join/FAMILY');
    expect(find.text('Sign in'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(session.store.value, 'saved');
    session.offline = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(joins, 1);
    expect(
      session.container
          .read(routerProvider)
          .routeInformationProvider
          .value
          .uri
          .path,
      '/stokvels/1',
    );
  });

  testWidgets('incorrect credentials and Retry-After countdown', (
    tester,
  ) async {
    final session = fixture()..loginStatus = 401;
    await launch(tester, session);
    await tester.pumpAndSettle();
    await signIn(tester, Persona.demo);
    expect(find.text('Email and password do not match.'), findsOneWidget);
    session.loginStatus = 429;
    final button = find.widgetWithText(FilledButton, 'Sign in');
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(
      find.text('Too many requests. Try again in 3 seconds.'),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    await tester.pump(const Duration(seconds: 2));
    expect(
      find.text('Too many requests. Try again in 1 seconds.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 1));
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
  });

  testWidgets(
    'registration errors stay on their fields and the join survives both forms',
    (tester) async {
      var joins = 0;
      final session = fixture(
        join: (code) async {
          expect(code, 'FAMILY');
          joins++;
          return 1;
        },
      )..registerStatus = 400;
      await launch(tester, session, '/join/FAMILY');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      for (final (label, value) in [
        ('First name', 'Lerato'),
        ('Last name', 'Fixture'),
        ('Email', Persona.demo.email),
        ('Phone number', '555123'),
        ('Password', sampleInput),
      ]) {
        await type(tester, label, value);
      }
      final submit = find.widgetWithText(FilledButton, 'Register');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid phone number.'), findsOneWidget);
      session.registerStatus = 409;
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.text('Email already registered.'), findsOneWidget);
      session.registerStatus = 201;
      await tester.tap(submit);
      await tester.pumpAndSettle();
      await signIn(tester, Persona.demo);
      final router = session.container.read(routerProvider);
      expect(router.routeInformationProvider.value.uri.path, '/stokvels/1');
      expect(find.text('Your role: Treasurer'), findsOneWidget);
      router.go('/join/FAMILY');
      await tester.pumpAndSettle();
      expect(joins, 1);
    },
  );

  for (final (failure, message) in [
    (
      const NotFoundFailure(),
      'Invite code not found. Check the code and try again.',
    ),
    (const RuleFailure('Ask for a new invite.'), 'Ask for a new invite.'),
  ]) {
    testWidgets('signed-out invite shows $message', (tester) async {
      final session = fixture(join: (_) async => throw failure);
      await launch(tester, session, '/join/INVALID');
      await tester.pumpAndSettle();
      await signIn(tester, Persona.demo);
      expect(find.text(message), findsOneWidget);
    });
  }

  testWidgets(
    'family phone removes Lerato’s treasurer state before the next account',
    (tester) async {
      final session = fixture();
      await launch(tester, session, '/stokvels/1');
      await tester.pumpAndSettle();
      await signIn(tester, Persona.demo);
      expect(find.text('Your role: Treasurer'), findsOneWidget);
      expect(session.container.exists(detailProvider(1)), isTrue);

      await tester.tap(find.text('Profile').last);
      await tester.pumpAndSettle();
      session.offline = true;
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      expect(session.store.value, isNull);
      expect(session.container.exists(detailProvider(1)), isFalse);
      expect(find.text('Your role: Treasurer'), findsNothing);

      session.offline = false;
      await signIn(tester, Persona.newcomer);
      expect(
        find.text('No stokvels yet. Ask a stokvel organiser for an invite.'),
        findsOneWidget,
      );
      expect(find.text('Community Savings'), findsNothing);
      expect(session.container.exists(detailProvider(1)), isFalse);
    },
  );
}
