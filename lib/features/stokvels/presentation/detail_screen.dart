import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/cache_status.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/core/south_african_day.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/contribution_list_screen.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/pay_form.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/presentation/cached_home_provider.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/actions.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/cached_stokvel_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/detail_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/presentation/stokvel_form.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

/// Displays the details of a selected stokvel.
class DetailScreen extends ConsumerWidget {
  const new({required this.stokvelId, this.cycleId, super.key});

  final int stokvelId;
  final String? cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.strings;
    final offline = ref.watch(offlineStorageEnabledProvider);
    // A real cycle link has its own provider key, including historical cycles.
    final api = ref.watch(useApiProvider);
    final provider = api && cycleId != null
        ? cycleDetailProvider(stokvelId, int.tryParse(cycleId!) ?? -1)
        : detailProvider(stokvelId);

    // Get the stokvels available to the current persona.
    final entries = offline
        ? ref.watch(cachedHomeProvider).value?.cached?.data ?? <HomeEntry>[]
        : ref.watch(homeProvider).value ?? <HomeEntry>[];
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
            : Text(strings.stokvel),
      ),

      // Display the appropriate loading, empty, error, or data state.
      body: offline
          ? _cachedBody(context, ref)
          : switch (toViewState(
              ref.watch(provider),
              isEmpty: (detail) => detail == null,
            )) {
              Loading() => Center(
                child: CircularProgressIndicator(
                  semanticsLabel: strings.stokvelLoading,
                ),
              ),
              Empty() => StateMessage(
                message: cycleId == null
                    ? strings.stokvelMissing
                    : strings.cycleMissing,
              ),
              Failure(:final message, :final apiFailure) => StateMessage(
                message: message,
                apiFailure: apiFailure,
                retry: () => ref.invalidate(provider),
              ),
              Data(:final value) =>
                cycleId != null &&
                        (cycleId != '${value!.currentCycle?.id}' ||
                            value.currentCycle?.stokvelId != stokvelId)
                    ? StateMessage(message: strings.cycleMissing)
                    : _DetailBody(
                        detail: value!,
                        isCycle: cycleId != null,
                        useApi: api,
                      ),
            },
    );
  }

  Widget _cachedBody(BuildContext context, WidgetRef ref) {
    final strings = context.strings;
    final key = (
      stokvelId: stokvelId,
      cycleId: cycleId == null ? null : int.tryParse(cycleId!) ?? -1,
    );
    final state = ref.watch(cachedStokvelProvider(key)).value;
    final cache = state?.cached;
    final sync = ref.watch(stokvelSyncProvider(key));
    final header = CacheStatus(
      updatedAt: cache?.updatedAt,
      refreshing: state?.refreshing ?? true,
      failure: state?.failure,
      retry: sync.refresh,
    );
    if (cache == null) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          header,
          if (state?.failure is NotFoundFailure)
            Text(
              cycleId == null ? strings.stokvelMissing : strings.cycleMissing,
            ),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: sync.refresh,
      child: _DetailBody(
        detail: cache.data,
        isCycle: cycleId != null,
        useApi: true,
        header: header,
      ),
    );
  }
}

/// Displays the stokvel's cycle, contributions, and available actions.
class _DetailBody extends ConsumerWidget {
  const new({
    required this.detail,
    required this.isCycle,
    required this.useApi,
    this.header,
  });

  final StokvelDetail detail;
  final bool isCycle;
  final bool useApi;
  final Widget? header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = context.strings;
    final cycle = detail.currentCycle;
    final offline = header != null;
    final pending = offline && cycle != null
        ? ref
              .watch(pendingPaymentsProvider)
              .value
              ?.where(
                (payment) =>
                    payment.target.stokvelId == detail.stokvel.id &&
                    payment.target.cycleId == cycle.id,
              )
              .toList()
        : null;

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
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        ?header,
        if (isCycle) Text(strings.cycleDetails),
        Text(
          detail.stokvel.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(strings.roleLabel(strings.membershipRole(detail.membership.role))),
        Text(strings.memberCount(detail.stokvel.memberCount)),
        Text(
          strings.contributionAmount(
            formatCents(detail.stokvel.contributionAmount),
          ),
        ),
        if (offline &&
            detail.membership.role == StokvelRole.chairperson &&
            detail.stokvel.version != null)
          TextButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => StokvelForm(initial: detail.stokvel),
              ),
            ),
            child: Text(strings.editStokvel),
          ),
        const SizedBox(height: 20),

        // Display the current contribution cycle, if available.
        if (cycle == null)
          Text(strings.noCycle)
        else ...[
          if (!isCycle)
            TextButton(
              onPressed: () => CycleRoute(
                id: '${detail.stokvel.id}',
                cycleId: '${cycle.id}',
              ).go(context),
              child: Text(strings.openCycle),
            ),
          Text(
            strings.cycleWithStatus(cycle.number, switch (cycle.status) {
              .active => strings.open,
              .closed => strings.closed,
              .paid => strings.paidOut,
              .unknown => strings.unknownStatus,
            }),
            style: TextStyle(
              color: Theme.of(context)
                  .extension<StatusColors>()
                  ?.cycles[cycle.status],
            ),
          ),
          Text(strings.dueDate(cycle.southAfricanDueDate)),
          if (offline &&
              cycle.status == CycleStatus.active &&
              (own == null || own.status == ContributionStatus.pending) &&
              !DateTime.now().isBefore(
                SouthAfricanDay.fromInstant(cycle.dueDateUtc).endUtcExclusive,
              ))
            Text(strings.late),
          Text(strings.targetAmount(formatCents(cycle.targetAmount))),
          Text(strings.requiredAmount(formatCents(cycle.requiredContribution))),
          TextButton(
            onPressed: () => PayoutsRoute(
              id: '${detail.stokvel.id}',
              cycleId: '${cycle.id}',
            ).go(context),
            child: Text(strings.payouts),
          ),
        ],

        const SizedBox(height: 20),
        Text(
          strings.contributions,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (offline)
          TextButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ContributionListScreen(stokvelId: detail.stokvel.id),
              ),
            ),
            child: Text(strings.viewContributions),
          ),
        for (final payment in pending ?? <PaymentIntent>[]) ...[
          Text(strings.pendingAmount(formatCents(payment.amount))),
          if (payment.retryAt case final retryAt?
              when retryAt.isAfter(DateTime.now()))
            Text(strings.waiting(context.formatTime(retryAt))),
        ],
        if (pending?.isNotEmpty ?? false)
          TextButton(
            onPressed: ref.read(paymentOutboxSyncProvider).flush,
            child: Text(strings.tryAgain),
          ),

        // Display each member's contribution.
        if (detail.contributions.isEmpty) Text(strings.noContributions),
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
                  strings.contributionStatus(contribution.status),
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
        Text(strings.actions, style: Theme.of(context).textTheme.titleLarge),

        if (actions.isEmpty) Text(strings.noActions),

        // Show permitted actions; implementation follows in Week 11.
        Wrap(
          spacing: 8,
          children: [
            for (final action in actions)
              OutlinedButton(
                onPressed:
                    action == StokvelAction.pay &&
                        (pending?.isNotEmpty ?? false)
                    ? null
                    : () {
                        if (offline &&
                            action == StokvelAction.pay &&
                            cycle != null) {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PayForm(
                                target: (
                                  stokvelId: detail.stokvel.id,
                                  cycleId: cycle.id,
                                  userId: detail.callerId,
                                ),
                                suggestedAmount: cycle.requiredContribution,
                              ),
                            ),
                          );
                          return;
                        }
                        if (useApi &&
                            action == StokvelAction.closeCycle &&
                            cycle != null) {
                          ClosePreviewRoute(
                            id: '${detail.stokvel.id}',
                            cycleId: '${cycle.id}',
                          ).go(context);
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.comingSoon)),
                        );
                      },
                child: Text(switch (action) {
                  .pay => strings.pay,
                  .uploadProof => strings.uploadProof,
                  .confirmContributions => strings.confirmContributions,
                  .closeCycle => strings.closeCycle,
                  .recordPayout => strings.recordPayout,
                }),
              ),
          ],
        ),
      ],
    );
  }
}
