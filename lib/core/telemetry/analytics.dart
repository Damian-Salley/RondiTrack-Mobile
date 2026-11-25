import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsProvider = Provider<Analytics>((ref) => const LocalAnalytics());

abstract interface class Analytics {
  void contributionRecorded({required int stokvelId, required int memberId});
}

class LocalAnalytics implements Analytics {
  const new();

  @override
  void contributionRecorded({required int stokvelId, required int memberId}) {}
}
