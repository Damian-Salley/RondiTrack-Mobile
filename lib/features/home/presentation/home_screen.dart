import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';

/// Displays the user's stokvels and their contribution information.
class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch Home data and convert it into a display state.
    final state = toViewState(
      ref.watch(homeProvider),
      isEmpty: (items) => items.isEmpty,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('RondiTrack')),
      body: switch (state) {
        Loading() => const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading home'),
        ),
        Empty() => const StateMessage(
          message: 'No stokvels yet. Ask a stokvel organiser for an invite.',
        ),
        Failure(:final message) => StateMessage(
          message: message,
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
              for (final entry in value) _HomeCard(entry: entry),
            ],
          ),
        ),
      },
    );
  }
}

/// Displays the contribution summary for one stokvel.
class _HomeCard extends StatelessWidget {
  const new({required this.entry});

  final HomeEntry entry;

  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      // Open the selected stokvel's detail screen.
      onTap: () =>
          StokvelRoute(id: '${entry.membership.stokvelId}').go(context),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              entry.stokvelName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Your role: ${entry.membership.role.label}'),

            // Display financial amounts using South African currency format.
            Text('Paid: ${formatCents(entry.paidThisCycle)}'),
            Text('Owed: ${formatCents(entry.stillOwes)}'),
            Text(
              'Arrears: ${formatCents(entry.arrears)}',
              style: TextStyle(
                color: Theme.of(context).extension<StatusColors>()?.arrears,
              ),
            ),
            Text(
              'Next payout: '
              '${entry.nextPayoutDate?.toIso8601String() ?? 'Not scheduled'}',
            ),
          ],
        ),
      ),
    ),
  );
}
