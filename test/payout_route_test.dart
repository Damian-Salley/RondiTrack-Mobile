import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';

void main() {
  testWidgets(
    'route: cold signed-out payouts survives sign-in in Stokvels tab',
    (tester) async {
      final container = ProviderContainer(retry: appRetry);
      addTearDown(container.dispose);
      const address = PayoutsRoute(id: '1', cycleId: '101');
      final router = container.read(routerProvider)
        ..go('ronditrack-dev://app${address.location}');
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const RondiTrackApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(2));
      await tester.enterText(find.byType(TextField).first, Persona.demo.email);
      await tester.enterText(find.byType(TextField).last, 'test input');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Rotation and payouts'), findsOneWidget);
      expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        1,
      );
      expect(router.routeInformationProvider.value.uri.path, address.location);
      router.pop();
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/stokvels/1/cycles/101',
      );
      expect(find.text('Cycle details'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
