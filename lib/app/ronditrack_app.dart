import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/payment_notice_text.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/l10n/language_preference.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

// Defines the main application and its appearance.
class RondiTrackApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<RondiTrackApp> createState() => _RondiTrackAppState();
}

class _RondiTrackAppState extends ConsumerState<RondiTrackApp> {
  late final AppLifecycleListener _lifecycle;
  final _messenger = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _syncPayments);
  }

  void _syncPayments() {
    if (ref.read(offlineStorageEnabledProvider) &&
        ref.read(authProvider) is SignedIn) {
      unawaited(ref.read(paymentOutboxSyncProvider).flush());
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(offlineStorageEnabledProvider)) {
      ref.listen(paymentNoticeProvider, (_, next) {
        final mountedContext = _messenger.currentContext;
        final notice = next.asData?.value;
        if (notice == null || mountedContext == null) return;
        _messenger.currentState?.showSnackBar(
          SnackBar(
            content: Text(paymentNoticeText(mountedContext.strings, notice)),
          ),
        );
      });
    }
    ref.listen(authProvider, (previous, next) {
      if (next is SignedIn && previous is! SignedIn) _syncPayments();
      if (next is SignedOut && previous is SignedIn) {
        _messenger.currentState?.clearSnackBars();
        ref.invalidate(paymentNoticeProvider);
      }
    });
    return MaterialApp.router(
      title: 'RondiTrack',
      scaffoldMessengerKey: _messenger,
      locale: ref.watch(languageProvider).value,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: rondiTheme(Brightness.light),
      darkTheme: rondiTheme(Brightness.dark),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
