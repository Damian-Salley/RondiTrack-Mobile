import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/cache_status.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/presentation/cached_home_provider.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';
import 'package:ronditrack_mobile/features/home/presentation/stokvel_card.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

/// Displays the user's stokvels and their contribution information.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.strings;
    if (ref.watch(offlineStorageEnabledProvider)) {
      final sync = ref.watch(homeSyncProvider);
      final state = ref.watch(cachedHomeProvider).value;
      final cached = state?.cached;
      return Scaffold(
        appBar: AppBar(title: Text(strings.appName)),
        body: RefreshIndicator(
          onRefresh: sync.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              CacheStatus(
                updatedAt: cached?.updatedAt,
                refreshing: state?.refreshing ?? true,
                failure: state?.failure,
                retry: sync.refresh,
                showReference: true,
              ),
              if (cached != null && cached.data.isEmpty)
                Text(strings.homeEmpty),
              for (final entry in cached?.data ?? <HomeEntry>[])
                _card(context, entry),
            ],
          ),
        ),
      );
    }
    // Watch Home data and convert it into a display state.
    final state = toViewState(
      ref.watch(homeProvider),
      isEmpty: (items) => items.isEmpty,
    );

    return Scaffold(
      appBar: AppBar(title: Text(strings.appName)),
      body: switch (state) {
        Loading() => Center(
          child: CircularProgressIndicator(semanticsLabel: strings.homeLoading),
        ),
        Empty() => StateMessage(message: strings.homeEmpty),
        Failure(:final message, :final apiFailure) => StateMessage(
          message: message,
          apiFailure: apiFailure,
          retryServerFailure: true,
          retry: () => ref.invalidate(homeProvider),
        ),
        Data(:final value, :final refreshing) => RefreshIndicator(
          // Reload Home data when the user pulls down.
          onRefresh: () => ref.refresh(homeProvider.future).then<void>((_) {}),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Keep existing cards visible while refreshing.
              if (refreshing) const LinearProgressIndicator(),
              for (final entry in value) _card(context, entry),
            ],
          ),
        ),
      },
    );
  }
}

Widget _card(BuildContext context, HomeEntry entry) => StokvelCard(
  entry: entry,
  onTap: () => StokvelRoute(id: '${entry.membership.stokvelId}').go(context),
);
