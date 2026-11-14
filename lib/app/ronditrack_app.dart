import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/router.dart';

// Defines the main application and its appearance.
class RondiTrackApp extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'RondiTrack',

    // Follow the phone's light/dark setting using the same RondiTrack seed.
    theme: rondiTheme(Brightness.light),
    darkTheme: rondiTheme(Brightness.dark),

    routerConfig: ref.watch(routerProvider),
  );
}
