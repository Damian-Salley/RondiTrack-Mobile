import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/cache_status.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/presentation/cached_home_provider.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/stokvel_form.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

class StokvelListScreen extends ConsumerWidget {
  const new({this.selectedId, super.key});

  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.strings;
    if (ref.watch(offlineStorageEnabledProvider)) {
      final sync = ref.watch(homeSyncProvider);
      final state = ref.watch(cachedHomeProvider).value;
      final cached = state?.cached;
      return Scaffold(
        appBar: AppBar(title: Text(strings.stokvelsTab)),
        body: RefreshIndicator(
          onRefresh: sync.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CacheStatus(
                      updatedAt: cached?.updatedAt,
                      refreshing: state?.refreshing ?? true,
                      failure: state?.failure,
                      retry: sync.refresh,
                    ),
                    FilledButton(
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute(builder: (_) => const StokvelForm()),
                      ),
                      child: Text(strings.createStokvel),
                    ),
                    if (cached != null && cached.data.isEmpty)
                      Text(strings.homeEmpty),
                  ],
                ),
              ),
              if (cached != null)
                for (final entry in cached.data)
                  ListTile(
                    selected: selectedId == '${entry.membership.stokvelId}',
                    title: Text(entry.stokvelName),
                    subtitle: Text(
                      strings.membershipRole(entry.membership.role),
                    ),
                    onTap: () =>
                        StokvelRoute(id: '${entry.membership.stokvelId}')
                            .go(context),
                  ),
            ],
          ),
        ),
      );
    }
    final state = toViewState(
      ref.watch(homeProvider),
      isEmpty: (entries) => entries.isEmpty,
    );
    return Scaffold(
      appBar: AppBar(title: Text(strings.stokvelsTab)),
      body: switch (state) {
        Loading() => const Center(child: CircularProgressIndicator()),
        Empty() => StateMessage(message: strings.noStokvels),
        Failure(:final message, :final apiFailure) => StateMessage(
          message: message,
          apiFailure: apiFailure,
          retry: () => ref.invalidate(homeProvider),
        ),
        Data(:final value) => ListView(
          children: [
            for (final entry in value)
              ListTile(
                selected: selectedId == '${entry.membership.stokvelId}',
                title: Text(entry.stokvelName),
                subtitle: Text(strings.membershipRole(entry.membership.role)),
                onTap: () =>
                    StokvelRoute(id: '${entry.membership.stokvelId}')
                        .go(context),
              ),
          ],
        ),
      },
    );
  }
}
