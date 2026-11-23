import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_af.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('af'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RondiTrack'**
  String get appName;

  /// No description provided for @noStokvels.
  ///
  /// In en, this message translates to:
  /// **'No stokvels yet.'**
  String get noStokvels;

  /// No description provided for @homeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading home'**
  String get homeLoading;

  /// No description provided for @homeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stokvels yet. Ask a stokvel organiser for an invite.'**
  String get homeEmpty;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline.'**
  String get offline;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing…'**
  String get refreshing;

  /// No description provided for @refreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t refresh.'**
  String get refreshFailed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time}'**
  String lastUpdated(String time);

  /// No description provided for @stokvel.
  ///
  /// In en, this message translates to:
  /// **'Stokvel'**
  String get stokvel;

  /// No description provided for @stokvelLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading stokvel'**
  String get stokvelLoading;

  /// No description provided for @stokvelMissing.
  ///
  /// In en, this message translates to:
  /// **'Stokvel not found.'**
  String get stokvelMissing;

  /// No description provided for @cycleMissing.
  ///
  /// In en, this message translates to:
  /// **'Cycle not found.'**
  String get cycleMissing;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @createStokvel.
  ///
  /// In en, this message translates to:
  /// **'Create stokvel'**
  String get createStokvel;

  /// No description provided for @editStokvel.
  ///
  /// In en, this message translates to:
  /// **'Edit stokvel'**
  String get editStokvel;

  /// No description provided for @stokvelName.
  ///
  /// In en, this message translates to:
  /// **'Stokvel name'**
  String get stokvelName;

  /// No description provided for @stokvelId.
  ///
  /// In en, this message translates to:
  /// **'Stokvel number'**
  String get stokvelId;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount in rand'**
  String get amount;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive rand amount with up to two decimal digits.'**
  String get invalidAmount;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the stokvel name.'**
  String get nameRequired;

  /// No description provided for @idRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive whole number.'**
  String get idRequired;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save. Try again.'**
  String get saveFailed;

  /// No description provided for @staleStokvel.
  ///
  /// In en, this message translates to:
  /// **'This stokvel changed. Review the latest details before saving again.'**
  String get staleStokvel;

  /// No description provided for @latestStokvel.
  ///
  /// In en, this message translates to:
  /// **'Latest details: {name}, {amount}'**
  String latestStokvel(String name, String amount);

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @payContribution.
  ///
  /// In en, this message translates to:
  /// **'Pay contribution'**
  String get payContribution;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get unknownStatus;

  /// No description provided for @pendingAmount.
  ///
  /// In en, this message translates to:
  /// **'Pending payment: {amount}'**
  String pendingAmount(String amount);

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Retry available at {time}'**
  String waiting(String time);

  /// No description provided for @storedPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment queued on this phone.'**
  String get storedPayment;

  /// No description provided for @paidPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded.'**
  String get paidPayment;

  /// No description provided for @refusedPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment refused. Check the cycle and your membership before trying again.'**
  String get refusedPayment;

  /// No description provided for @expiredPayment.
  ///
  /// In en, this message translates to:
  /// **'The payment expired. Check whether it went through before paying again.'**
  String get expiredPayment;

  /// No description provided for @contributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get contributions;

  /// No description provided for @firstPageLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading contributions'**
  String get firstPageLoading;

  /// No description provided for @noContributions.
  ///
  /// In en, this message translates to:
  /// **'There are no contributions yet.'**
  String get noContributions;

  /// No description provided for @noFilteredContributions.
  ///
  /// In en, this message translates to:
  /// **'No contributions match these filters.'**
  String get noFilteredContributions;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @firstPageFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load contributions.'**
  String get firstPageFailed;

  /// No description provided for @nextPageFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load the next page.'**
  String get nextPageFailed;

  /// No description provided for @endOfContributions.
  ///
  /// In en, this message translates to:
  /// **'End of contributions'**
  String get endOfContributions;

  /// No description provided for @cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get toDate;

  /// No description provided for @invalidDateRange.
  ///
  /// In en, this message translates to:
  /// **'The end date must be on or after the start date.'**
  String get invalidDateRange;

  /// No description provided for @cycleNumber.
  ///
  /// In en, this message translates to:
  /// **'Cycle {number}'**
  String cycleNumber(int number);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use phone language'**
  String get systemLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @afrikaans.
  ///
  /// In en, this message translates to:
  /// **'Afrikaans'**
  String get afrikaans;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @discardPayments.
  ///
  /// In en, this message translates to:
  /// **'Discard pending payments and sign out?'**
  String get discardPayments;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @discardAndSignOut.
  ///
  /// In en, this message translates to:
  /// **'Discard and sign out'**
  String get discardAndSignOut;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Your role: {role}'**
  String roleLabel(String role);

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid: {amount}'**
  String paidAmount(String amount);

  /// No description provided for @owedAmount.
  ///
  /// In en, this message translates to:
  /// **'Owed: {amount}'**
  String owedAmount(String amount);

  /// No description provided for @arrearsAmount.
  ///
  /// In en, this message translates to:
  /// **'Arrears: {amount}'**
  String arrearsAmount(String amount);

  /// No description provided for @nextPayout.
  ///
  /// In en, this message translates to:
  /// **'Next payout: {date}'**
  String nextPayout(String date);

  /// No description provided for @unscheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get unscheduled;

  /// No description provided for @treasurer.
  ///
  /// In en, this message translates to:
  /// **'Treasurer'**
  String get treasurer;

  /// No description provided for @chairperson.
  ///
  /// In en, this message translates to:
  /// **'Chairperson'**
  String get chairperson;

  /// No description provided for @unknownRole.
  ///
  /// In en, this message translates to:
  /// **'Unknown role'**
  String get unknownRole;

  /// No description provided for @duplicatePayment.
  ///
  /// In en, this message translates to:
  /// **'A contribution for this cycle was already recorded.'**
  String get duplicatePayment;

  /// No description provided for @paymentMembership.
  ///
  /// In en, this message translates to:
  /// **'You can no longer pay for this stokvel or member.'**
  String get paymentMembership;

  /// No description provided for @paymentClosed.
  ///
  /// In en, this message translates to:
  /// **'This cycle is closed or can’t accept the payment.'**
  String get paymentClosed;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @paidOut.
  ///
  /// In en, this message translates to:
  /// **'Paid out'**
  String get paidOut;

  /// No description provided for @cycleDetails.
  ///
  /// In en, this message translates to:
  /// **'Cycle details'**
  String get cycleDetails;

  /// No description provided for @noCycle.
  ///
  /// In en, this message translates to:
  /// **'No current cycle.'**
  String get noCycle;

  /// No description provided for @openCycle.
  ///
  /// In en, this message translates to:
  /// **'Open cycle'**
  String get openCycle;

  /// No description provided for @cycleWithStatus.
  ///
  /// In en, this message translates to:
  /// **'Cycle {number}: {status}'**
  String cycleWithStatus(int number, String status);

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String dueDate(String date);

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target: {amount}'**
  String targetAmount(String amount);

  /// No description provided for @requiredAmount.
  ///
  /// In en, this message translates to:
  /// **'Required: {amount}'**
  String requiredAmount(String amount);

  /// No description provided for @contributionAmount.
  ///
  /// In en, this message translates to:
  /// **'Contribution: {amount}'**
  String contributionAmount(String amount);

  /// No description provided for @payouts.
  ///
  /// In en, this message translates to:
  /// **'View rotation and payouts'**
  String get payouts;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Available actions'**
  String get actions;

  /// No description provided for @noActions.
  ///
  /// In en, this message translates to:
  /// **'No actions available for this cycle.'**
  String get noActions;

  /// No description provided for @uploadProof.
  ///
  /// In en, this message translates to:
  /// **'Upload proof'**
  String get uploadProof;

  /// No description provided for @confirmContributions.
  ///
  /// In en, this message translates to:
  /// **'Confirm contributions'**
  String get confirmContributions;

  /// No description provided for @closeCycle.
  ///
  /// In en, this message translates to:
  /// **'Close cycle'**
  String get closeCycle;

  /// No description provided for @recordPayout.
  ///
  /// In en, this message translates to:
  /// **'Record payout'**
  String get recordPayout;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in Week 11.'**
  String get comingSoon;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @stokvelsTab.
  ///
  /// In en, this message translates to:
  /// **'Stokvels'**
  String get stokvelsTab;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @pageMissing.
  ///
  /// In en, this message translates to:
  /// **'Page not found.'**
  String get pageMissing;

  /// No description provided for @filtersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load filter options.'**
  String get filtersUnavailable;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more contributions'**
  String get loadMore;

  /// No description provided for @viewContributions.
  ///
  /// In en, this message translates to:
  /// **'View contribution history'**
  String get viewContributions;

  /// No description provided for @chosenStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date: {date}'**
  String chosenStartDate(String date);

  /// No description provided for @chosenEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date: {date}'**
  String chosenEndDate(String date);

  /// No description provided for @contributionWhen.
  ///
  /// In en, this message translates to:
  /// **'{date}, {time} SAST'**
  String contributionWhen(String date, String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['af', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'af':
      return AppLocalizationsAf();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
