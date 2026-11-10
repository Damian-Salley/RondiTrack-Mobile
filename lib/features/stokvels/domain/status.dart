/// Represents the current status of a contribution cycle.
enum CycleStatus {
  active,
  closed,
  paid,
  unknown;

  // Convert the API response into a Dart enum.
  static CycleStatus fromApi(String value) => switch (value) {
    'Active' => .active,
    'Closed' => .closed,
    'Paid' => .paid,
    _ => .unknown,
  };

  // Display a readable status in the application.
  String get label => switch (this) {
    .active => 'Open',
    .closed => 'Closed',
    .paid => 'Paid out',
    .unknown => 'Unknown cycle status',
  };
}

/// Represents the payment status of a contribution.
enum ContributionStatus {
  pending,
  paid,
  confirmed,
  unknown;

  // Convert the API response into a Dart enum.
  static ContributionStatus fromApi(String value) => switch (value) {
    'Pending' => .pending,
    'Paid' => .paid,
    'Confirmed' => .confirmed,
    _ => .unknown,
  };

  // Display a readable contribution status.
  String get label => switch (this) {
    .pending => 'Pending',
    .paid => 'Paid',
    .confirmed => 'Confirmed',
    .unknown => 'Unknown contribution status',
  };
}

/// Represents a user's role within a stokvel.
enum StokvelRole {
  member,
  treasurer,
  chairperson,
  unknown;

  // Convert the API response into a Dart enum.
  static StokvelRole fromApi(String value) => switch (value) {
    'Member' => .member,
    'Treasurer' => .treasurer,
    'Chairperson' => .chairperson,
    _ => .unknown,
  };

  // Display a readable role name.
  String get label => switch (this) {
    .member => 'Member',
    .treasurer => 'Treasurer',
    .chairperson => 'Chairperson',
    .unknown => 'Unknown role',
  };
}
