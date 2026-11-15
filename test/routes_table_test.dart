import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

void main() {
  const screens = {
    '/sign-in': 'Sign in',
    '/home': 'RondiTrack',
    '/stokvels': 'Stokvels',
    '/stokvels/:id': 'Your role: Treasurer',
    '/stokvels/:id/cycles/:cycleId': 'Cycle details',
    '/stokvels/:id/cycles/:cycleId/payouts': 'Rotation and payouts',
    '/activity': 'Activity',
    '/profile': 'Profile',
    '/join/:code': 'Invite code: family',
  };

  test(
    'route: README table and address checks cover exactly the same screens',
    () {
      final documented = RegExp(r'^\| `(/[^`]+)` \|', multiLine: true)
          .allMatches(File('README.md').readAsStringSync())
          .map((match) => match[1]);
      expect(documented.toSet(), screens.keys.toSet());
      expect(documented.length, screens.length);
    },
  );

  for (final entry in screens.entries) {
    testWidgets('route: README ${entry.key} opens ${entry.value}', (
      tester,
    ) async {
      final container = ProviderContainer(retry: appRetry);
      addTearDown(container.dispose);
      if (entry.key != '/sign-in') {
        container.read(authProvider.notifier).signIn(Persona.demo.email);
      }
      final address = entry.key
          .replaceAll(':id', '1')
          .replaceAll(':cycleId', '101')
          .replaceAll(':code', 'family');
      final router = container.read(routerProvider)..go(address);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const RondiTrackApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, address);
      expect(find.text(entry.value), findsWidgets);
      expect(find.text('Page not found.'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
