import 'package:flutter/material.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_screen.dart';

// Defines the main application and its appearance.
class RondiTrackApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RondiTrack',

    // Apply a consistent green theme throughout the application.
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF186B52)),
      useMaterial3: true,
    ),

    // Display the Home screen when the application starts.
    home: const HomeScreen(),
  );
}
