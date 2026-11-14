import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/actions.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_provider.dart';

/// Displays the details of a selected stokvel.
class DetailScreen extends ConsumerWidget {
  const new({required this.stokvelId, this.cycleId, super.key});

  final int stokvelId;
  final String? cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected stokvel without storing its details locally.
    final state = toViewState(
      ref.watch(detailProvider(stokvelId)),
      isEmpty: (detail) => detail == null,
    );

    // Get the stokvels available to the current persona.
    final entries = ref.watch(homeProvider).value ?? [];
    final choices = {
      for (final item in entries) item.membership.stokvelId: item,
    };

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64 * MediaQuery.textScalerOf(context).scale(1),
        title: choices.containsKey(stokvelId)
            ? DropdownButton<int>(
                key: const Key('stokvel-picker'),
                value: stokvelId,
                isExpanded: true,
                itemHeight: null,
                style: Theme.of(context).textTheme.titleMedium,
                items: [
                  for (final MapEntry(key: id, value: entry) in choices.entries)
                    DropdownMenuItem(value: id, child: Text(entry.stokvelName)),
                ],
                // Switch to another stokvel when selected.
                onChanged: (id) {
                  if (id != null) StokvelRoute(id: '$id').go(context);
                },
              )
            : const Text('Stokvel'),
      ),

      // Display the appropriate loading, empty, error, or data state.
      body: switch (state) {
        Loading() => const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading stokvel'),
        ),
        Empty() => StateMessage(
          message: cycleId == null ? 'Stokvel not found.' : 'Cycle not found.',
        ),
        Failure(:final message) => StateMessage(
          message: message,
          retry: () => ref.invalidate(detailProvider(stokvelId)),
        ),
        Data(:final value) =>
          cycleId != null &&
                  (cycleId != '${value!.currentCycle?.id}' ||
                      value.currentCycle?.stokvelId != stokvelId)
              ? const StateMessage(message: 'Cycle not found.')
              : _DetailBody(detail: value!, isCycle: cycleId != null),
      },
    );
  }
}

/// Displays the stokvel's cycle, contributions, and available actions.
class _DetailBody extends StatelessWidget {
  const new({required this.detail, required this.isCycle});

  final StokvelDetail detail;
  final bool isCycle;

  @override
  Widget build(BuildContext context) {
    final cycle = detail.currentCycle;

    // Find the current user's contribution, if one exists.
    final own = detail.contributions
        .where((item) => item.userId == detail.callerId)
        .firstOrNull;

    // Determine which actions the user's role and cycle status allow.
    final actions = allowedActions(
      (
        detail.membership.role,
        cycle?.status ?? CycleStatus.unknown,
        own?.status,
      ),
      hasPaidContributions: detail.contributions.any(
        (item) => item.status == .paid,
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (isCycle) const Text('Cycle details'),
        Text(
          detail.stokvel.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text('Your role: ${detail.membership.role.label}'),
        Text('Members: ${detail.stokvel.memberCount}'),
        Text('Contribution: ${formatCents(detail.stokvel.contributionAmount)}'),
        const SizedBox(height: 20),

        // Display the current contribution cycle, if available.
        if (cycle == null)
          const Text('No current cycle.')
        else ...[
          if (!isCycle)
            TextButton(
              onPressed: () => CycleRoute(
                id: '${detail.stokvel.id}',
                cycleId: '${cycle.id}',
              ).go(context),
              child: const Text('Open cycle'),
            ),
          Text(
            'Cycle ${cycle.number}: ${cycle.status.label}',
            style: TextStyle(
              color: Theme.of(context)
                  .extension<StatusColors>()
                  ?.cycles[cycle.status],
            ),
          ),
          Text('Due (UTC): ${cycle.dueDateUtc.toIso8601String()}'),
          Text('Target: ${formatCents(cycle.targetAmount)}'),
          Text('Required: ${formatCents(cycle.requiredContribution)}'),
        ],

        const SizedBox(height: 20),
        Text('Contributions', style: Theme.of(context).textTheme.titleLarge),

        // Display each member's contribution.
        if (detail.contributions.isEmpty) const Text('No contributions yet.'),
        for (final contribution in detail.contributions)
          ListTile(
            key: ValueKey('${detail.stokvel.id}-${contribution.userId}'),
            contentPadding: EdgeInsets.zero,
            title: Text(contribution.memberName),
            // Keep amount under the name so large text has room to wrap.
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contribution.status.label,
                  style: TextStyle(
                    color: Theme.of(context)
                        .extension<StatusColors>()
                        ?.contributions[contribution.status],
                  ),
                ),
                Text(formatCents(contribution.amount)),
              ],
            ),
          ),

        const SizedBox(height: 20),
        Text(
          'Available actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        if (actions.isEmpty) const Text('No actions available for this cycle.'),

        // Show permitted actions; implementation follows in Week 11.
        Wrap(
          spacing: 8,
          children: [
            for (final action in actions)
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming in Week 11.')),
                  );
                },
                child: Text(action.label),
              ),
          ],
        ),
      ],
    );
  }
}
