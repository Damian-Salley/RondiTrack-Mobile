import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main supplies its validated native config. The default also lets widget tests
// run a dev app; prod/staging tests override it with those validated configs.
final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.validate(
    flavor: const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
    apiBaseUrl: const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://localhost',
    ),
    nativeFlavor: const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
  ),
);

/// Stores the application's public configuration settings.
class AppConfig {
  const new _(this.flavor, this.apiBaseUrl);

  factory validate({
    required String flavor,
    required String apiBaseUrl,
    required String? nativeFlavor,
  }) {
    // Only allow the three flavours required by the assignment.
    // The API address must also be provided.
    if (!const {'dev', 'staging', 'prod'}.contains(flavor) ||
        apiBaseUrl.isEmpty) {
      throw StateError('Supply --dart-define-from-file=config/<flavor>.json');
    }

    // Ensure the selected Android flavour matches the configuration file.
    if (nativeFlavor != flavor) {
      throw StateError('Native flavour and config must match.');
    }

    // Check that the API address is a valid HTTP or HTTPS URL.
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !const {'http', 'https'}.contains(uri.scheme)) {
      throw StateError('API_BASE_URL must be an absolute HTTP(S) address.');
    }

    // Return the validated configuration.
    return AppConfig._(flavor, uri);
  }

  final String flavor;
  final Uri apiBaseUrl;
}
