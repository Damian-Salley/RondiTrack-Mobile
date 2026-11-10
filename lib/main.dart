import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';

void main() {
  // Initialise Flutter before accessing platform-specific functionality.
  WidgetsFlutterBinding.ensureInitialized();

  // Check that the required API configuration and app flavour are valid.
  AppConfig.validate(
    flavor: const String.fromEnvironment('FLAVOR'),
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    nativeFlavor: appFlavor,
  );

  // Start the application with Riverpod state management enabled.
  runApp(const ProviderScope(child: RondiTrackApp()));
}
