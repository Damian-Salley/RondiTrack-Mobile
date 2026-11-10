import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

enum StokvelAction {
  pay,
  uploadProof,
  confirmContributions,
  closeCycle,
  recordPayout;

  String get label => switch (this) {
    .pay => 'Pay',
    .uploadProof => 'Upload proof',
    .confirmContributions => 'Confirm contributions',
    .closeCycle => 'Close cycle',
    .recordPayout => 'Record payout',
  };
}

/// Null means no contribution exists. Unknown means an unrecognised API value.
/// Explicit status patterns make new enum cases a compiler error here.
/// Confirmation also needs an existing paid row, regardless of your own row.
Set<StokvelAction> allowedActions(
  (StokvelRole, CycleStatus, ContributionStatus?) context, {
  required bool hasPaidContributions,
}) => switch (context) {
  (
    .unknown,
    .active || .closed || .paid || .unknown,
    null || .pending || .paid || .confirmed || .unknown,
  ) =>
    {},
  (
    .member || .treasurer || .chairperson,
    .closed || .paid || .unknown,
    null || .pending || .paid || .confirmed || .unknown,
  ) =>
    {},
  (.member || .treasurer || .chairperson, .active, .unknown) => {},
  (.member, .active, null) => {.pay},
  (.member, .active, .pending || .paid || .confirmed) => {.uploadProof},
  (.treasurer, .active, null) => {
    .pay,
    if (hasPaidContributions) .confirmContributions,
    .closeCycle,
    .recordPayout,
  },
  (.treasurer, .active, .pending || .paid || .confirmed) => {
    .uploadProof,
    if (hasPaidContributions) .confirmContributions,
    .closeCycle,
    .recordPayout,
  },
  (.chairperson, .active, null) => {.pay, .recordPayout},
  (.chairperson, .active, .pending || .paid || .confirmed) => {
    .uploadProof,
    .recordPayout,
  },
};
