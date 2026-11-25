import 'package:flutter/material.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

/// Displays the contribution summary for one stokvel.
class StokvelCard extends StatelessWidget {
  const new({required this.entry, required this.onTap, super.key});

  final HomeEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Card(
      child: InkWell(
        onTap: onTap,
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
              Text(
                strings.roleLabel(
                  strings.membershipRole(entry.membership.role),
                ),
              ),

              // Display financial amounts using South African currency format.
              if (entry.cycleStatus == CycleStatus.unknown)
                Text(strings.unknownStatus),
              Text(strings.paidAmount(formatCents(entry.paidThisCycle))),
              Text(strings.owedAmount(formatCents(entry.stillOwes))),
              Text(
                strings.arrearsAmount(formatCents(entry.arrears)),
                style: TextStyle(
                  color: Theme.of(context).extension<StatusColors>()?.arrears,
                ),
              ),
              Text(
                strings.nextPayout(
                  entry.nextPayoutDate?.toIso8601String() ??
                      strings.unscheduled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
