import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/payout_providers.dart';
import 'package:ronditrack_mobile/features/payouts/presentation/payout_screen.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

import 'support/repositories.dart';

Future<void> showPayouts(
  WidgetTester tester,
  PayoutRepository repository, {
  Brightness brightness = Brightness.light,
  double textScale = 1,
}) async {
  final container = ProviderContainer(
    retry: appRetry,
    overrides: [
      payoutRepositoryProvider.overrideWithValue(repository),
      stokvelRepositoryProvider.overrideWithValue(
        const FakeStokvelRepository(Persona.demo, delay: Duration.zero),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.read(authProvider.notifier).signIn(Persona.demo.email);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: rondiTheme(brightness),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: const PayoutScreen(cycle: (stokvelId: 1, cycleId: 101)),
      ),
    ),
  );
}

void main() {
  testWidgets('screen: loading then empty is visible', (tester) async {
    final result = Completer<List<PayoutEntry>>();
    await showPayouts(tester, TestPayoutRepository((_) => result.future));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    result.complete([]);
    await tester.pumpAndSettle();
    expect(find.text('No payout order yet.'), findsOneWidget);
    expect(find.text('Record payout'), findsNothing);
  });

  testWidgets('screen: failure retries and not found never retries', (
    tester,
  ) async {
    var calls = 0;
    await showPayouts(
      tester,
      TestPayoutRepository((_) async {
        if (++calls == 1) throw StateError('offline');
        return [];
      }),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Could not load your data. Please try again.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.text('No payout order yet.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await showPayouts(
      tester,
      TestPayoutRepository((_) async => throw const PayoutNotFound()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cycle not found.'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  for (final brightness in Brightness.values) {
    testWidgets(
      'screen: server order, rands, every status and $brightness tokens',
      (tester) async {
        final rows = [
          testPayout,
          PayoutEntry(
            userId: 1,
            memberName: 'Server second',
            position: 1,
            amount: const Cents(50010),
            status: .paid,
            paidAtUtc: DateTime.utc(2026, 11),
          ),
          testPayout.copyWith(userId: 3, memberName: 'Third', status: .waiting),
          testPayout.copyWith(
            userId: 4,
            memberName: 'Fourth',
            status: .unknown,
          ),
        ];
        await showPayouts(
          tester,
          TestPayoutRepository((_) async => rows),
          brightness: brightness,
        );
        await tester.pumpAndSettle();
        expect(
          tester.getTopLeft(find.text('9. Server first')).dy,
          lessThan(tester.getTopLeft(find.text('1. Server second')).dy),
        );
        expect(find.text('R\u00a0123,45'), findsWidgets);
        expect(find.text('R\u00a0500,10'), findsOneWidget);
        for (final status in PayoutStatus.values) {
          await tester.scrollUntilVisible(find.text(status.label), 120);
          final text = tester.widget<Text>(find.text(status.label));
          expect(
            text.style!.color,
            rondiTheme(brightness).extension<StatusColors>()!.payout(status),
          );
        }
        expect(
          find.text('Paid (UTC): 2026-11-01T00:00:00.000Z'),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.text('Record payout').hitTestable(),
          120,
        );
        await tester.tap(find.text('Record payout'));
        await tester.pumpAndSettle();
        expect(find.text('Coming in Week 11.'), findsOneWidget);
      },
    );
  }

  testWidgets(
    'screen: 360 dp at 200 percent has no overflow through all rows',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await showPayouts(
        tester,
        TestPayoutRepository((_) async => [testPayout]),
        textScale: 2,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('Record payout'), 100);
      expect(find.text('Record payout').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
