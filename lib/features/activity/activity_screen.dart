import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

// Reuse the selected persona's repositories; no second set of fake records.
final FutureProvider<List<Contribution>> activityProvider =
    FutureProvider.autoDispose<List<Contribution>>((ref) async {
      final home = ref.watch(homeRepositoryProvider);
      final stokvels = ref.watch(stokvelRepositoryProvider);
      final entries = await home.fetchHome();
      final details = await Future.wait([
        for (final entry in entries)
          stokvels.fetchDetail(entry.membership.stokvelId),
      ]);
      return [for (final detail in details) ...?detail?.contributions];
    });

class ActivityScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = toViewState(
      ref.watch(activityProvider),
      isEmpty: (items) => items.isEmpty,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: switch (state) {
        Loading() => const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading activity'),
        ),
        Empty() => const StateMessage(message: 'No activity yet.'),
        Failure(:final message) => StateMessage(
          message: message,
          retry: () => ref.invalidate(activityProvider),
        ),
        Data(:final value) => ListView(
          children: [
            for (final item in value)
              ListTile(
                title: Text(item.memberName),
                subtitle: Text(
                  'Stokvel ${item.stokvelId} · ${item.status.label}\n'
                  '${formatCents(item.amount)}',
                ),
              ),
          ],
        ),
      },
    );
  }
}
