import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_mobile/app/auth_redirect.dart';
import 'package:ronditrack_mobile/core/breakpoints.dart';
import 'package:ronditrack_mobile/features/activity/activity_screen.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_screen.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/session/presentation/profile_screen.dart';
import 'package:ronditrack_mobile/features/session/presentation/sign_in_screen.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_screen.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/join_screen.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/stokvel_list_screen.dart';

part 'router.g.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Auth refreshes this router without replacing its navigation stacks.
  final refresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => refresh.value++);
  final router = GoRouter(
    routes: $appRoutes,
    initialLocation: const HomeRoute().location,
    refreshListenable: refresh,
    redirect: (_, state) => authRedirect(ref.read(authProvider), state.uri),
    errorBuilder: (_, _) =>
        const Scaffold(body: Center(child: Text('Page not found.'))),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});

@TypedGoRoute<SignInRoute>(path: '/sign-in')
class SignInRoute extends GoRouteData with $SignInRoute {
  const new({this.from});
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignInScreen();
}

@TypedGoRoute<JoinRoute>(path: '/join/:code')
class JoinRoute extends GoRouteData with $JoinRoute {
  const new({required this.code});
  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) const HomeRoute().go(context);
    },
    child: JoinScreen(code: code),
  );
}

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: '/home')],
    ),
    TypedStatefulShellBranch<StokvelsBranch>(
      routes: [
        TypedGoRoute<StokvelsRoute>(
          path: '/stokvels',
          routes: [
            TypedGoRoute<StokvelRoute>(
              path: ':id',
              routes: [TypedGoRoute<CycleRoute>(path: 'cycles/:cycleId')],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ActivityBranch>(
      routes: [TypedGoRoute<ActivityRoute>(path: '/activity')],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [TypedGoRoute<ProfileRoute>(path: '/profile')],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const new();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => _AppShell(shell: navigationShell);
}

class HomeBranch extends StatefulShellBranchData {
  const new();
}

class StokvelsBranch extends StatefulShellBranchData {
  const new();
}

class ActivityBranch extends StatefulShellBranchData {
  const new();
}

class ProfileBranch extends StatefulShellBranchData {
  const new();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const new();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class StokvelsRoute extends GoRouteData with $StokvelsRoute {
  const new();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StokvelListScreen();
}

class StokvelRoute extends GoRouteData with $StokvelRoute {
  const new({required this.id});
  final String id;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      _StokvelPage(id: id);
}

class CycleRoute extends GoRouteData with $CycleRoute {
  const new({required this.id, required this.cycleId});
  final String id;
  final String cycleId;
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      _StokvelPage(id: id, cycleId: cycleId);
}

class ActivityRoute extends GoRouteData with $ActivityRoute {
  const new();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivityScreen();
}

class ProfileRoute extends GoRouteData with $ProfileRoute {
  const new();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}

class _StokvelPage extends StatelessWidget {
  const new({required this.id, this.cycleId});
  final String id;
  final String? cycleId;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // Both panes represent one address; rotation never changes the selection.
      if (MediaQuery.sizeOf(context).width >= expandedWidth)
        SizedBox(width: 280, child: StokvelListScreen(selectedId: id)),
      Expanded(
        child: DetailScreen(
          stokvelId: int.tryParse(id) ?? -1,
          cycleId: cycleId,
        ),
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const new({required this.shell});
  final StatefulNavigationShell shell;
  static const List<(IconData, String)> _tabs = [
    (Icons.home_outlined, 'Home'),
    (Icons.groups_outlined, 'Stokvels'),
    (Icons.history, 'Activity'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= mediumWidth;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Keep the branch shell in the same slot across window changes.
            if (wide)
              NavigationRail(
                selectedIndex: shell.currentIndex,
                onDestinationSelected: shell.goBranch,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final (icon, label) in _tabs)
                    NavigationRailDestination(
                      icon: Icon(icon),
                      label: Text(label),
                    ),
                ],
              )
            else
              const SizedBox.shrink(),
            Expanded(child: shell),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: shell.currentIndex,
              // Reselecting a tab keeps its page and scroll.
              onDestinationSelected: shell.goBranch,
              destinations: [
                for (final (icon, label) in _tabs)
                  NavigationDestination(icon: Icon(icon), label: label),
              ],
            ),
    );
  }
}
