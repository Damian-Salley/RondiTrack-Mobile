import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/presentation/stokvel_card.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

void main() {
  group('Stokvel card', () {
    for (final brightness in Brightness.values) {
      // Registers tests synchronously.
      // ignore: discarded_futures
      goldenTest(
        brightness.name,
        fileName: 'stokvel_card_${brightness.name}',
        builder: () => GoldenTestGroup(
          columns: 3,
          // Use integer column offsets on every host.
          columnWidthBuilder: (_) => const FixedColumnWidth(416),
          children: [
            for (final role in [StokvelRole.treasurer, StokvelRole.member])
              for (final (label, arrears, status) in [
                ('Arrears', 5000, CycleStatus.active),
                ('Up to date', 0, CycleStatus.active),
                ('Unknown', 0, CycleStatus.unknown),
              ])
                GoldenTestScenario(
                  name: '${role.name} / $label',
                  child: Builder(
                    builder: (context) {
                      final theme = rondiTheme(brightness);
                      final font = Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.fontFamily;
                      final text = theme.textTheme.apply(fontFamily: font);
                      return Theme(
                        data: theme.copyWith(
                          textTheme: font == 'Ahem'
                              ? text.copyWith(
                                  bodyMedium: text.bodyMedium?.copyWith(
                                    letterSpacing: 0,
                                  ),
                                  titleLarge: text.titleLarge?.copyWith(
                                    letterSpacing: 0,
                                  ),
                                )
                              : text,
                        ),
                        child: Localizations(
                          locale: const Locale('en'),
                          delegates: AppLocalizations.localizationsDelegates,
                          child: SizedBox(
                            width: 320,
                            child: StokvelCard(
                              entry: HomeEntry(
                                stokvelName: 'Community Savings',
                                membership: Membership(
                                  stokvelId: 1,
                                  role: role,
                                ),
                                paidThisCycle: const Cents(25000),
                                stillOwes: Cents(arrears),
                                arrears: Cents(arrears),
                                totalCollected: const Cents(50000),
                                cycleStatus: status,
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      );
    }
  });
}
