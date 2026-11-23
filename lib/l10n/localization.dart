import 'package:flutter/material.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/l10n/generated/app_localizations.dart';
import 'package:ronditrack_mobile/l10n/generated/app_localizations_en.dart';

export 'generated/app_localizations.dart' show AppLocalizations;

extension LocalizedContext on BuildContext {
  AppLocalizations get strings =>
      AppLocalizations.of(this) ?? AppLocalizationsEn();

  String formatTime(DateTime time) {
    final local = time.toLocal();
    final formatter = MaterialLocalizations.of(this);
    final day = formatter.formatShortDate(local);
    final hour = formatter.formatTimeOfDay(TimeOfDay.fromDateTime(local));
    return '$day $hour';
  }
}

extension LocalizedStatuses on AppLocalizations {
  String contributionStatus(ContributionStatus value) => switch (value) {
    .pending => pending,
    .paid => paid,
    .confirmed => confirmed,
    .unknown => unknownStatus,
  };

  String membershipRole(StokvelRole value) => switch (value) {
    .member => member,
    .treasurer => treasurer,
    .chairperson => chairperson,
    .unknown => unknownRole,
  };
}
