import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_theme.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

void main() {
  test('theme: every payout status uses its measured light and dark pair', () {
    for (final brightness in Brightness.values) {
      final theme = rondiTheme(brightness);
      final tokens = theme.extension<StatusColors>()!;
      for (final (status, reused) in [
        (PayoutStatus.paid, ContributionStatus.paid),
        (PayoutStatus.next, ContributionStatus.confirmed),
        (PayoutStatus.waiting, ContributionStatus.pending),
        (PayoutStatus.unknown, ContributionStatus.unknown),
      ]) {
        final foreground = tokens.payout(status);
        expect(foreground, tokens.contributions[reused]);
        final a = foreground.computeLuminance();
        final b = theme.colorScheme.surface.computeLuminance();
        final ratio = a > b ? (a + .05) / (b + .05) : (b + .05) / (a + .05);
        expect(ratio, greaterThanOrEqualTo(4.5));
        // Evidence comes from Flutter's actual theme surface and colour values.
        debugPrint(
          '${brightness.name}|payout.${status.name}|'
          '${ratio.toStringAsFixed(2)}',
        );
      }
    }
  });
}
