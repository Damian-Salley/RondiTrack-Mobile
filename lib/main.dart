import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/core/telemetry/error_reporter.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/l10n/language_preference.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Initialise Flutter before accessing platform-specific functionality.
  WidgetsFlutterBinding.ensureInitialized();

  // Check that the required API configuration and app flavour are valid.
  final config = AppConfig.validate(
    flavor: const String.fromEnvironment('FLAVOR'),
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    refreshCookieName: const String.fromEnvironment('REFRESH_COOKIE_NAME'),
    nativeFlavor: appFlavor,
  );

  const dsn = String.fromEnvironment('SENTRY_DSN');
  final container = ProviderContainer(
    retry: appRetry,
    overrides: [
      appConfigProvider.overrideWithValue(config),
      useApiProvider.overrideWithValue(true),
      offlineStorageEnabledProvider.overrideWithValue(true),
      languagePreferencesProvider.overrideWithValue(SharedPreferencesAsync()),
      if (dsn.isNotEmpty)
        errorReporterProvider.overrideWithValue(const SentryErrorReporter()),
    ],
  );
  void start() => runApp(
    UncontrolledProviderScope(
      container: container,
      child: const RondiTrackApp(),
    ),
  );

  if (dsn.isEmpty) {
    start();
    return;
  }
  String? memberName;
  Future<void> rememberMemberName(SignedIn session) async {
    try {
      final profile = await container
          .read(apiClientProvider)
          .rest
          .me
          .getApiV1Me();
      if (identical(container.read(authProvider), session)) {
        memberName = '${profile.firstName} ${profile.lastName}'.trim();
      }
    } on Object {
      // Offline sessions can continue without the optional profile lookup.
    }
  }

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = dsn
        ..environment = config.flavor
        ..sendDefaultPii = false
        ..sendClientReports = false
        ..enableAutoSessionTracking = false
        ..enableAutoPerformanceTracing = false
        ..enableNativeCrashHandling = false
        ..enableWatchdogTerminationTracking = false
        ..enableAppHangTracking = false
        ..enableAutoNativeBreadcrumbs = false
        ..enableUserInteractionBreadcrumbs = false
        ..enableUserInteractionTracing = false
        ..enablePrintBreadcrumbs = false
        ..enableScopeSync = false
        ..beforeSend = (event, hint) =>
            scrubEvent(event, memberName: memberName);
    },
    appRunner: () {
      container.listen(authProvider, (_, next) {
        memberName = null;
        if (next is SignedIn) unawaited(rememberMemberName(next));
      });
      start();
    },
  );
}
