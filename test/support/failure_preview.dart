// Emulator-only evidence harness. Production startup never imports this file.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/ronditrack_app.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';

import 'repositories.dart';

void main() {
  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      overrides: [
        homeRepositoryProvider.overrideWithValue(
          TestHomeRepository(() async => throw StateError('Preview failure')),
        ),
      ],
      child: const RondiTrackApp(),
    ),
  );
}
