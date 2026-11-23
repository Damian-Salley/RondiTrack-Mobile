// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Afrikaans (`af`).
class AppLocalizationsAf extends AppLocalizations {
  AppLocalizationsAf([String locale = 'af']) : super(locale);

  @override
  String get homeLoading => 'Laai tuisblad';

  @override
  String get homeEmpty =>
      'Nog geen stokvelle nie. Vra ’n stokvelorganiseerder vir ’n uitnodiging.';

  @override
  String get offline => 'Jy is vanlyn.';

  @override
  String get refreshing => 'Besig om te verfris…';

  @override
  String get refreshFailed => 'Kon nie verfris nie.';

  @override
  String get tryAgain => 'Probeer weer';

  @override
  String lastUpdated(String time) {
    return 'Laas bygewerk $time';
  }

  @override
  String get stokvel => 'Stokvel';

  @override
  String get stokvelLoading => 'Laai stokvel';

  @override
  String get stokvelMissing => 'Stokvel nie gevind nie.';

  @override
  String get cycleMissing => 'Siklus nie gevind nie.';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lede',
      one: '1 lid',
    );
    return '$_temp0';
  }

  @override
  String get createStokvel => 'Skep stokvel';

  @override
  String get editStokvel => 'Wysig stokvel';

  @override
  String get stokvelName => 'Stokvelnaam';

  @override
  String get stokvelId => 'Stokvelnommer';

  @override
  String get save => 'Stoor';

  @override
  String get amount => 'Bedrag in rand';

  @override
  String get invalidAmount =>
      'Voer ’n positiewe randbedrag met hoogstens twee desimale syfers in.';

  @override
  String get nameRequired => 'Voer die stokvelnaam in.';

  @override
  String get idRequired => 'Voer ’n positiewe heelgetal in.';

  @override
  String get saveFailed => 'Kon nie stoor nie. Probeer weer.';

  @override
  String get staleStokvel =>
      'Hierdie stokvel het verander. Hersien die jongste besonderhede voordat jy weer stoor.';

  @override
  String latestStokvel(String name, String amount) {
    return 'Jongste besonderhede: $name, $amount';
  }

  @override
  String get pay => 'Betaal';

  @override
  String get payContribution => 'Betaal bydrae';

  @override
  String get pending => 'Hangende';

  @override
  String get paid => 'Betaal';

  @override
  String get confirmed => 'Bevestig';

  @override
  String get late => 'Laat';

  @override
  String get unknownStatus => 'Onbekende status';

  @override
  String pendingAmount(String amount) {
    return 'Hangende betaling: $amount';
  }

  @override
  String waiting(String time) {
    return 'Kan weer probeer om $time';
  }

  @override
  String get storedPayment =>
      'Betaling is op hierdie foon in die waglys geplaas.';

  @override
  String get paidPayment => 'Betaling aangeteken.';

  @override
  String get refusedPayment =>
      'Betaling geweier. Kontroleer die siklus en jou lidmaatskap voordat jy weer probeer.';

  @override
  String get expiredPayment =>
      'Die betaling het verval. Kyk of dit deurgegaan het voordat jy weer betaal.';

  @override
  String get contributions => 'Bydraes';

  @override
  String get firstPageLoading => 'Laai bydraes';

  @override
  String get noContributions => 'Daar is nog geen bydraes nie.';

  @override
  String get noFilteredContributions =>
      'Geen bydraes pas by hierdie filters nie.';

  @override
  String get clearFilters => 'Maak filters skoon';

  @override
  String get firstPageFailed => 'Kon nie bydraes laai nie.';

  @override
  String get nextPageFailed => 'Kon nie die volgende bladsy laai nie.';

  @override
  String get endOfContributions => 'Einde van bydraes';

  @override
  String get cycle => 'Siklus';

  @override
  String get status => 'Status';

  @override
  String get member => 'Lid';

  @override
  String get all => 'Almal';

  @override
  String get fromDate => 'Begindatum';

  @override
  String get toDate => 'Einddatum';

  @override
  String get invalidDateRange =>
      'Die einddatum moet op of ná die begindatum wees.';

  @override
  String cycleNumber(int number) {
    return 'Siklus $number';
  }

  @override
  String get profile => 'Profiel';

  @override
  String get language => 'Taal';

  @override
  String get systemLanguage => 'Gebruik foontaal';

  @override
  String get english => 'Engels';

  @override
  String get afrikaans => 'Afrikaans';

  @override
  String get signOut => 'Meld af';

  @override
  String get discardPayments => 'Gooi hangende betalings weg en meld af?';

  @override
  String get cancel => 'Kanselleer';

  @override
  String get discardAndSignOut => 'Gooi weg en meld af';

  @override
  String roleLabel(String role) {
    return 'Jou rol: $role';
  }

  @override
  String paidAmount(String amount) {
    return 'Betaal: $amount';
  }

  @override
  String owedAmount(String amount) {
    return 'Verskuldig: $amount';
  }

  @override
  String arrearsAmount(String amount) {
    return 'Agterstallig: $amount';
  }

  @override
  String nextPayout(String date) {
    return 'Volgende uitbetaling: $date';
  }

  @override
  String get unscheduled => 'Nie geskeduleer nie';

  @override
  String get treasurer => 'Tesourier';

  @override
  String get chairperson => 'Voorsitter';

  @override
  String get unknownRole => 'Onbekende rol';

  @override
  String get duplicatePayment =>
      '’n Bydrae vir hierdie siklus is reeds aangeteken.';

  @override
  String get paymentMembership =>
      'Jy kan nie meer vir hierdie stokvel of lid betaal nie.';

  @override
  String get paymentClosed =>
      'Hierdie siklus is gesluit of kan nie die betaling aanvaar nie.';

  @override
  String get open => 'Oop';

  @override
  String get closed => 'Gesluit';

  @override
  String get paidOut => 'Uitbetaal';

  @override
  String get cycleDetails => 'Siklusbesonderhede';

  @override
  String get noCycle => 'Geen huidige siklus nie.';

  @override
  String get openCycle => 'Maak siklus oop';

  @override
  String cycleWithStatus(int number, String status) {
    return 'Siklus $number: $status';
  }

  @override
  String dueDate(String date) {
    return 'Betaalbaar: $date';
  }

  @override
  String targetAmount(String amount) {
    return 'Teiken: $amount';
  }

  @override
  String requiredAmount(String amount) {
    return 'Vereis: $amount';
  }

  @override
  String contributionAmount(String amount) {
    return 'Bydrae: $amount';
  }

  @override
  String get payouts => 'Wys beurtvolgorde en uitbetalings';

  @override
  String get actions => 'Beskikbare aksies';

  @override
  String get noActions => 'Geen aksies vir hierdie siklus beskikbaar nie.';

  @override
  String get uploadProof => 'Laai bewys op';

  @override
  String get confirmContributions => 'Bevestig bydraes';

  @override
  String get closeCycle => 'Sluit siklus';

  @override
  String get recordPayout => 'Teken uitbetaling aan';

  @override
  String get comingSoon => 'Beskikbaar in week 11.';

  @override
  String get homeTab => 'Tuis';

  @override
  String get stokvelsTab => 'Stokvelle';

  @override
  String get activity => 'Aktiwiteit';

  @override
  String get pageMissing => 'Bladsy nie gevind nie.';

  @override
  String get filtersUnavailable => 'Kon nie filteropsies laai nie.';

  @override
  String get loadMore => 'Laai meer bydraes';

  @override
  String get viewContributions => 'Wys bydraegeskiedenis';

  @override
  String chosenStartDate(String date) {
    return 'Begindatum: $date';
  }

  @override
  String chosenEndDate(String date) {
    return 'Einddatum: $date';
  }

  @override
  String contributionWhen(String date, String time) {
    return '$date, $time SAST';
  }
}
