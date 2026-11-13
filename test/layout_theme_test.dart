import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_screen.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/stokvel_list_screen.dart';

void main() {
  for (final route in [
    const HomeRoute().location,
    const StokvelsRoute().location,
    const StokvelRoute(id: '1').location,
  ]) {
    testWidgets('$route at 360x640 and 200 percent has no overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(authProvider.notifier).signIn(Persona.demo.email);
      container.read(routerProvider).go(route);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(360, 640),
              textScaler: TextScaler.linear(2),
            ),
            child: MaterialApp.router(
              theme: rondiTheme(Brightness.light),
              routerConfig: container.read(routerProvider),
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(tester.takeException(), isNull);
      // Walk the entire scrollable content, including every available action.
      for (var i = 0; i < 14; i++) {
        await tester.drag(find.byType(ListView).last, const Offset(0, -180));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      if (route == const StokvelRoute(id: '1').location) {
        expect(find.text('Record payout').hitTestable(), findsOneWidget);
        await tester.tap(find.text('Record payout'));
        await tester.pumpAndSettle();
        expect(find.text('Coming in Week 11.'), findsOneWidget);
      }
    });
  }

  testWidgets('tablet panes share an address and survive rotation and back', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(authProvider.notifier).signIn(Persona.demo.email);
    final router = container.read(routerProvider)
      ..go(const StokvelRoute(id: '2').location);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const RondiTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    final list = find.byType(StokvelListScreen);
    final detail = find.byType(DetailScreen);
    expect(list, findsOneWidget);
    expect(detail, findsOneWidget);
    expect(
      tester.getRect(list).right,
      lessThanOrEqualTo(tester.getRect(detail).left),
    );
    expect(tester.takeException(), isNull);
    tester.view.physicalSize = const Size(700, 1000);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(StokvelListScreen), findsNothing);
    expect(find.text('Your role: Member'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/stokvels/2');
    tester.view.physicalSize = const Size(599, 800);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(StokvelListScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('theme tokens meet measured WCAG contrast in both themes', () {
    for (final brightness in Brightness.values) {
      final theme = rondiTheme(brightness);
      final scheme = theme.colorScheme;
      final status = theme.extension<StatusColors>()!;
      final pairs = <String, (Color, Color, double)>{
        'onSurface': (scheme.onSurface, scheme.surface, 4.5),
        'onSurfaceVariant': (scheme.onSurfaceVariant, scheme.surface, 4.5),
        'primary': (scheme.primary, scheme.surface, 4.5),
        'onPrimary': (scheme.onPrimary, scheme.primary, 4.5),
        'outline': (scheme.outline, scheme.surface, 3),
        'arrears': (status.arrears, scheme.surface, 4.5),
        for (final item in status.contributions.entries)
          'contribution.${item.key.name}': (item.value, scheme.surface, 4.5),
        for (final item in status.cycles.entries)
          'cycle.${item.key.name}': (item.value, scheme.surface, 4.5),
      };
      for (final MapEntry(key: name, value: (fg, bg, minimum))
          in pairs.entries) {
        final a = fg.computeLuminance();
        final b = bg.computeLuminance();
        final contrast =
            (a > b ? a + 0.05 : b + 0.05) / (a > b ? b + 0.05 : a + 0.05);
        expect(
          contrast,
          greaterThanOrEqualTo(minimum),
          reason: '$brightness $name',
        );
        // Retain deterministic measurements for the README's token table.
        debugPrint(
          '${brightness.name}|$name|'
          '${fg.toARGB32().toRadixString(16)}|'
          '${bg.toARGB32().toRadixString(16)}|'
          '${contrast.toStringAsFixed(2)}',
        );
      }
    }
  });
}
