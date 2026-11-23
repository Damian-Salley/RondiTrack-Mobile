import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/south_african_day.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/contributions/domain/contribution_page.dart';
import 'package:ronditrack_mobile/features/contributions/presentation/contribution_paging.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

class ContributionListScreen extends ConsumerStatefulWidget {
  const new({required this.stokvelId, super.key});

  final int stokvelId;

  @override
  ConsumerState<ContributionListScreen> createState() =>
      _ContributionListState();
}

class _ContributionListState extends ConsumerState<ContributionListScreen> {
  late final ContributionPaging _paging;

  @override
  void initState() {
    super.initState();
    final history = ref.read(contributionHistoryProvider);
    _paging = ContributionPaging(
      (filters, token) => history.fetch(widget.stokvelId, filters, token),
    );
    unawaited(_paging.refresh());
  }

  @override
  void dispose() {
    _paging.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool start}) async {
    final strings = context.strings;
    final filters = _paging.filters;
    final min = start ? null : filters.from;
    final max = start ? filters.to : null;
    final initial = start ? filters.from : filters.to;
    final date = await showDatePicker(
      context: context,
      firstDate: min == null ? DateTime(1900) : _displayDate(min),
      lastDate: max == null ? DateTime(2100, 12, 31) : _displayDate(max),
      initialDate: _displayDate(
        initial ?? min ?? max ?? SouthAfricanDay.fromInstant(DateTime.now()),
      ),
      helpText: start ? strings.fromDate : strings.toDate,
    );
    if (!mounted || date == null) return;
    final selected = SouthAfricanDay(date.year, date.month, date.day);
    await _paging.changeFilters((
      cycleId: filters.cycleId,
      status: filters.status,
      memberId: filters.memberId,
      from: start ? selected : filters.from,
      to: start ? filters.to : selected,
    ));
  }

  DateTime _displayDate(SouthAfricanDay date) =>
      DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final options = ref.watch(
      contributionFilterOptionsProvider(widget.stokvelId),
    );
    return Scaffold(
      appBar: AppBar(title: Text(strings.contributions)),
      body: ListenableBuilder(
        listenable: _paging,
        builder: (context, _) {
          final rows = _paging.rows;
          final filters = _paging.filters;
          final filtered = filters != emptyContributionFilters;
          final failure = _paging.failure;
          return RefreshIndicator(
            onRefresh: _paging.refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (event) {
                if (event.metrics.extentAfter < 250 &&
                    rows.isNotEmpty &&
                    failure == null &&
                    event is ScrollUpdateNotification) {
                  unawaited(_paging.next());
                }
                return false;
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _filters(context, options.value),
                  if (options.hasError)
                    TextButton(
                      onPressed: () => ref.invalidate(
                        contributionFilterOptionsProvider(widget.stokvelId),
                      ),
                      child: Text(strings.filtersUnavailable),
                    ),
                  if (filtered)
                    OutlinedButton(
                      onPressed: () =>
                          _paging.changeFilters(emptyContributionFilters),
                      child: Text(strings.clearFilters),
                    ),
                  if (_paging.loading)
                    LinearProgressIndicator(
                      semanticsLabel: strings.firstPageLoading,
                    ),
                  if (_paging.loading && rows.isEmpty)
                    Text(strings.firstPageLoading),
                  if (failure == PageFailure.first) ...[
                    Text(strings.firstPageFailed),
                    TextButton(
                      onPressed: _paging.refresh,
                      child: Text(strings.tryAgain),
                    ),
                  ],
                  if (rows.isEmpty && !_paging.loading && failure == null)
                    Text(
                      filtered
                          ? strings.noFilteredContributions
                          : strings.noContributions,
                    ),
                  for (final row in rows)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(row.memberName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.contributionStatus(row.status)),
                          Text(formatCents(row.amount)),
                          if (row.paidAtUtc case final date?)
                            Text(_paymentDate(context, date)),
                        ],
                      ),
                    ),
                  if (failure == PageFailure.later) ...[
                    Text(strings.nextPageFailed),
                    TextButton(
                      onPressed: _paging.next,
                      child: Text(strings.tryAgain),
                    ),
                  ] else if (_paging.ended && rows.isNotEmpty)
                    Text(strings.endOfContributions)
                  else if (!_paging.loading &&
                      failure == null &&
                      rows.isNotEmpty)
                    TextButton(
                      onPressed: _paging.next,
                      child: Text(strings.loadMore),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filters(BuildContext context, FilterOptions? options) {
    final strings = context.strings;
    final filters = _paging.filters;
    final cycleLabels = {
      if (options != null)
        for (final cycle in options.cycles)
          cycle.id: strings.cycleNumber(cycle.number),
    };
    final memberLabels = {
      if (options != null)
        for (final member in options.members) member.id: member.name,
    };
    final dateFormatter = MaterialLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        _dropdown(
          label: strings.cycle,
          current: filters.cycleId,
          values: cycleLabels,
          change: (cycle) => _paging.changeFilters((
            cycleId: cycle,
            status: filters.status,
            memberId: filters.memberId,
            from: filters.from,
            to: filters.to,
          )),
        ),
        _dropdown(
          label: strings.status,
          current: filters.status,
          values: {
            for (final status in [
              ContributionStatus.pending,
              ContributionStatus.paid,
              ContributionStatus.confirmed,
            ])
              status: strings.contributionStatus(status),
          },
          change: (status) => _paging.changeFilters((
            cycleId: filters.cycleId,
            status: status,
            memberId: filters.memberId,
            from: filters.from,
            to: filters.to,
          )),
        ),
        _dropdown(
          label: strings.member,
          current: filters.memberId,
          values: memberLabels,
          change: (member) => _paging.changeFilters((
            cycleId: filters.cycleId,
            status: filters.status,
            memberId: member,
            from: filters.from,
            to: filters.to,
          )),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            OutlinedButton(
              onPressed: () => _pickDate(start: true),
              child: Text(
                filters.from == null
                    ? strings.fromDate
                    : strings.chosenStartDate(
                        dateFormatter.formatCompactDate(
                          _displayDate(filters.from!),
                        ),
                      ),
              ),
            ),
            OutlinedButton(
              onPressed: () => _pickDate(start: false),
              child: Text(
                filters.to == null
                    ? strings.toDate
                    : strings.chosenEndDate(
                        dateFormatter.formatCompactDate(
                          _displayDate(filters.to!),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _paymentDate(BuildContext context, DateTime instant) {
    final clock = SouthAfricanDay.clockAt(instant);
    final format = MaterialLocalizations.of(context);
    return context.strings.contributionWhen(
      format.formatMediumDate(
        _displayDate(SouthAfricanDay.fromInstant(instant)),
      ),
      format.formatTimeOfDay(
        TimeOfDay(hour: clock.hour, minute: clock.minute),
        alwaysUse24HourFormat: true,
      ),
    );
  }

  Widget _dropdown<T extends Object>({
    required String label,
    required T? current,
    required Map<T, String> values,
    required ValueChanged<T?> change,
  }) => DropdownButtonFormField<T>(
    key: ValueKey((label, current)),
    initialValue: values.containsKey(current) ? current : null,
    decoration: InputDecoration(labelText: label),
    isExpanded: true,
    items: [
      DropdownMenuItem(child: Text(context.strings.all)),
      for (final entry in values.entries)
        DropdownMenuItem(value: entry.key, child: Text(entry.value)),
    ],
    onChanged: values.isEmpty ? null : change,
  );
}
