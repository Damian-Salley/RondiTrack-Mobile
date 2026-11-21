import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/presentation/payout_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/actions.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_provider.dart';

class PayoutScreen extends ConsumerWidget {
  const new({required this.cycle, super.key});
  final PayoutCycle cycle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(payoutViewProvider(cycle));
    final detail = ref.watch(detailProvider(cycle.stokvelId));
    // AsyncValue can retain the previous persona during reload. Never use it.
    final current = detail.isLoading || detail.hasError ? null : detail.value;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64 * MediaQuery.textScalerOf(context).scale(1),
        title: const Text('Rotation and payouts'),
      ),
      body: switch (state) {
        Loading() => const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading payouts'),
        ),
        Empty() => const StateMessage(message: 'No payout order yet.'),
        Failure(:final message, :final apiFailure) => StateMessage(
          message: message,
          apiFailure: apiFailure,
          retry: message == 'Cycle not found.'
              ? null
              : () => ref.invalidate(payoutsProvider(cycle)),
        ),
        Data(:final value) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Preserve response order, including unusual positions.
            for (final entry in value) _PayoutRow(entry: entry),
            if (current != null && _canRecord(current))
              OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming in Week 11.')),
                ),
                child: const Text('Record payout'),
              ),
          ],
        ),
      },
    );
  }

  bool _canRecord(StokvelDetail detail) {
    if (detail.currentCycle?.id != cycle.cycleId) return false;
    final own = detail.contributions
        .where((row) => row.userId == detail.callerId)
        .firstOrNull;
    return allowedActions(
      (
        detail.membership.role,
        detail.currentCycle?.status ?? CycleStatus.unknown,
        own?.status,
      ),
      hasPaidContributions: detail.contributions.any(
        (row) => row.status == .paid,
      ),
    ).contains(StokvelAction.recordPayout);
  }
}

class _PayoutRow extends StatelessWidget {
  const new({required this.entry});
  final PayoutEntry entry;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text('${entry.position}. ${entry.memberName}'),
          Text(formatCents(entry.amount)),
          Text(
            entry.status.label,
            style: TextStyle(
              color: Theme.of(context)
                  .extension<StatusColors>()!
                  .payout(entry.status),
              fontWeight: entry.status == PayoutStatus.next
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          if (entry.paidAtUtc case final date?)
            Text('Paid (UTC): ${date.toIso8601String()}'),
        ],
      ),
    ),
  );
}
