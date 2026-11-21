import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main supplies network configuration. Fake widget tests only need a flavour.
final appConfigProvider = Provider<AppConfig>(
  (ref) => const AppConfig._('dev', null, ''),
);

/// Stores the application's public configuration settings.
class AppConfig {
  const new _(this.flavor, this._apiBaseUrl, this.refreshCookieName);

  factory validate({
    required String flavor,
    required String apiBaseUrl,
    required String? nativeFlavor,
    required String refreshCookieName,
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

    // Only the dev build may connect to the local backend over plain HTTP.
    if (flavor != 'dev' && uri.scheme != 'https') {
      throw StateError('Staging and production API addresses must use HTTPS.');
    }

    // Return the validated configuration.
    if (!RegExp(r'^[!#$%&\x27*+.^_`|~0-9A-Za-z-]+$')
        .hasMatch(refreshCookieName)) {
      throw StateError('REFRESH_COOKIE_NAME must be a valid cookie name.');
    }
    return AppConfig._(flavor, uri, refreshCookieName);
  }

  final String flavor;
  final String refreshCookieName;
  final Uri? _apiBaseUrl;

  Uri get apiBaseUrl =>
      _apiBaseUrl ?? (throw StateError('The API address is not configured.'));
}
