import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

part 'models.freezed.dart';

/// Stores a user's role within a specific stokvel.
@freezed
abstract class Membership with _$Membership {
  const factory({required int stokvelId, required StokvelRole role}) =
      _Membership;
}

/// Stores the basic information about a stokvel.
@freezed
abstract class Stokvel with _$Stokvel {
  const factory({
    required int id,
    required String name,
    required Cents contributionAmount,
    required int memberCount,
  }) = _Stokvel;
}

/// Stores information about a stokvel's contribution cycle.
@freezed
abstract class Cycle with _$Cycle {
  const factory({
    required int id,
    required int stokvelId,
    required int number,
    required CycleStatus status,
    required DateTime dueDateUtc,
    required Cents targetAmount,
    required Cents requiredContribution,
  }) = _Cycle;
}

/// Stores a member's contribution and payment status.
@freezed
abstract class Contribution with _$Contribution {
  const factory({
    required int userId,
    required int stokvelId,
    required int cycleId,
    required String memberName,
    required Cents amount,
    required ContributionStatus status,
    DateTime? paidAtUtc,
  }) = _Contribution;
}

/// Combines existing API responses into one stokvel detail model.
/// This does not require a separate detail API endpoint.
@freezed
abstract class StokvelDetail with _$StokvelDetail {
  const factory({
    required Stokvel stokvel,
    required Membership membership,
    required int callerId,
    required List<Contribution> contributions,
    Cycle? currentCycle,
  }) = _StokvelDetail;
}
