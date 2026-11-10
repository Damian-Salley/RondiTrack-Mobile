import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

part 'home_entry.freezed.dart';

/// Represents one stokvel card displayed on the Home screen.
@freezed
abstract class HomeEntry with _$HomeEntry {
  const factory({
    required Membership membership,
    required String stokvelName,

    // Financial amounts are stored as whole cents.
    required Cents paidThisCycle,
    required Cents stillOwes,
    required Cents arrears,
    required Cents totalCollected,

    // Cycle and payout information may be unavailable.
    int? currentCycle,
    CycleStatus? cycleStatus,
    DateTime? nextPayoutDate,
  }) = _HomeEntry;
}
