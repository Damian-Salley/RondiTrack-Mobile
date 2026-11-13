import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/features/activity/activity_screen.dart';
import 'package:ronditrack_mobile/features/home/data/fake_home_repository.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

void main() {
  testWidgets('activity renders loading and empty', (tester) async {
    final pending = Completer<List<Contribution>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [activityProvider.overrideWith((ref) => pending.future)],
        child: const MaterialApp(home: ActivityScreen()),
      ),
    );
    expect(find.bySemanticsLabel('Loading activity'), findsOneWidget);
    pending.complete([]);
    await tester.pumpAndSettle();
    expect(find.text('No activity yet.'), findsOneWidget);
  });

  testWidgets('activity renders failure and retries', (tester) async {
    var fail = true;
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          activityProvider.overrideWith((ref) async {
            if (fail) throw StateError('offline');
            return [];
          }),
        ],
        child: const MaterialApp(home: ActivityScreen()),
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
    expect(find.text('No activity yet.'), findsOneWidget);
  });

  testWidgets('activity combines the signed-in personas stokvels', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const FakeHomeRepository(Persona.demo, delay: Duration.zero),
          ),
          stokvelRepositoryProvider.overrideWithValue(
            const FakeStokvelRepository(Persona.demo, delay: Duration.zero),
          ),
        ],
        child: const MaterialApp(home: ActivityScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Stokvel 1'), findsNWidgets(2));
    expect(find.textContaining('Stokvel 2'), findsOneWidget);
  });
}
