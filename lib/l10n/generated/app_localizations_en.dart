// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RondiTrack';

  @override
  String get noStokvels => 'No stokvels yet.';

  @override
  String get homeLoading => 'Loading home';

  @override
  String get homeEmpty =>
      'No stokvels yet. Ask a stokvel organiser for an invite.';

  @override
  String get offline => 'You are offline.';

  @override
  String get refreshing => 'Refreshing…';

  @override
  String get refreshFailed => 'Couldn’t refresh.';

  @override
  String get tryAgain => 'Try again';

  @override
  String lastUpdated(String time) {
    return 'Last updated $time';
  }

  @override
  String get stokvel => 'Stokvel';

  @override
  String get stokvelLoading => 'Loading stokvel';

  @override
  String get stokvelMissing => 'Stokvel not found.';

  @override
  String get cycleMissing => 'Cycle not found.';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get createStokvel => 'Create stokvel';

  @override
  String get editStokvel => 'Edit stokvel';

  @override
  String get stokvelName => 'Stokvel name';

  @override
  String get stokvelId => 'Stokvel number';

  @override
  String get save => 'Save';

  @override
  String get amount => 'Amount in rand';

  @override
  String get invalidAmount =>
      'Enter a positive rand amount with up to two decimal digits.';

  @override
  String get nameRequired => 'Enter the stokvel name.';

  @override
  String get idRequired => 'Enter a positive whole number.';

  @override
  String get saveFailed => 'Couldn’t save. Try again.';

  @override
  String get staleStokvel =>
      'This stokvel changed. Review the latest details before saving again.';

  @override
  String latestStokvel(String name, String amount) {
    return 'Latest details: $name, $amount';
  }

  @override
  String get pay => 'Pay';

  @override
  String get payContribution => 'Pay contribution';

  @override
  String get pending => 'Pending';

  @override
  String get paid => 'Paid';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get late => 'Late';

  @override
  String get unknownStatus => 'Unknown status';

  @override
  String pendingAmount(String amount) {
    return 'Pending payment: $amount';
  }

  @override
  String waiting(String time) {
    return 'Retry available at $time';
  }

  @override
  String get storedPayment => 'Payment queued on this phone.';

  @override
  String get paidPayment => 'Payment recorded.';

  @override
  String get refusedPayment =>
      'Payment refused. Check the cycle and your membership before trying again.';

  @override
  String get expiredPayment =>
      'The payment expired. Check whether it went through before paying again.';

  @override
  String get contributions => 'Contributions';

  @override
  String get firstPageLoading => 'Loading contributions';

  @override
  String get noContributions => 'There are no contributions yet.';

  @override
  String get noFilteredContributions => 'No contributions match these filters.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get firstPageFailed => 'Couldn’t load contributions.';

  @override
  String get nextPageFailed => 'Couldn’t load the next page.';

  @override
  String get endOfContributions => 'End of contributions';

  @override
  String get cycle => 'Cycle';

  @override
  String get status => 'Status';

  @override
  String get member => 'Member';

  @override
  String get all => 'All';

  @override
  String get fromDate => 'Start date';

  @override
  String get toDate => 'End date';

  @override
  String get invalidDateRange =>
      'The end date must be on or after the start date.';

  @override
  String cycleNumber(int number) {
    return 'Cycle $number';
  }

  @override
  String get profile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'Use phone language';

  @override
  String get english => 'English';

  @override
  String get afrikaans => 'Afrikaans';

  @override
  String get signOut => 'Sign out';

  @override
  String get discardPayments => 'Discard pending payments and sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get discardAndSignOut => 'Discard and sign out';

  @override
  String roleLabel(String role) {
    return 'Your role: $role';
  }

  @override
  String paidAmount(String amount) {
    return 'Paid: $amount';
  }

  @override
  String owedAmount(String amount) {
    return 'Owed: $amount';
  }

  @override
  String arrearsAmount(String amount) {
    return 'Arrears: $amount';
  }

  @override
  String nextPayout(String date) {
    return 'Next payout: $date';
  }

  @override
  String get unscheduled => 'Not scheduled';

  @override
  String get treasurer => 'Treasurer';

  @override
  String get chairperson => 'Chairperson';

  @override
  String get unknownRole => 'Unknown role';

  @override
  String get duplicatePayment =>
      'A contribution for this cycle was already recorded.';

  @override
  String get paymentMembership =>
      'You can no longer pay for this stokvel or member.';

  @override
  String get paymentClosed =>
      'This cycle is closed or can’t accept the payment.';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get paidOut => 'Paid out';

  @override
  String get cycleDetails => 'Cycle details';

  @override
  String get noCycle => 'No current cycle.';

  @override
  String get openCycle => 'Open cycle';

  @override
  String cycleWithStatus(int number, String status) {
    return 'Cycle $number: $status';
  }

  @override
  String dueDate(String date) {
    return 'Due: $date';
  }

  @override
  String targetAmount(String amount) {
    return 'Target: $amount';
  }

  @override
  String requiredAmount(String amount) {
    return 'Required: $amount';
  }

  @override
  String contributionAmount(String amount) {
    return 'Contribution: $amount';
  }

  @override
  String get payouts => 'View rotation and payouts';

  @override
  String get actions => 'Available actions';

  @override
  String get noActions => 'No actions available for this cycle.';

  @override
  String get uploadProof => 'Upload proof';

  @override
  String get confirmContributions => 'Confirm contributions';

  @override
  String get closeCycle => 'Close cycle';

  @override
  String get recordPayout => 'Record payout';

  @override
  String get comingSoon => 'Coming in Week 11.';

  @override
  String get homeTab => 'Home';

  @override
  String get stokvelsTab => 'Stokvels';

  @override
  String get activity => 'Activity';

  @override
  String get pageMissing => 'Page not found.';

  @override
  String get filtersUnavailable => 'Couldn’t load filter options.';

  @override
  String get loadMore => 'Load more contributions';

  @override
  String get viewContributions => 'View contribution history';

  @override
  String chosenStartDate(String date) {
    return 'Start date: $date';
  }

  @override
  String chosenEndDate(String date) {
    return 'End date: $date';
  }

  @override
  String contributionWhen(String date, String time) {
    return '$date, $time SAST';
  }
}
