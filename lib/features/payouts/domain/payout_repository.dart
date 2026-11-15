import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';

/// A value key: stokvel and cycle IDs keep families stable across rebuilds.
typedef PayoutCycle = ({int stokvelId, int cycleId});

final class PayoutNotFound implements Exception {
  const new();
}

abstract interface class PayoutRepository {
  /// Empty means a known cycle without an order; inaccessible means not found.
  Future<List<PayoutEntry>> fetchOrder(PayoutCycle cycle);
}
