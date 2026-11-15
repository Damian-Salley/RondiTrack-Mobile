import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ronditrack_mobile/core/money.dart';

part 'payout.freezed.dart';

enum PayoutStatus {
  paid,
  next,
  waiting,
  unknown;

  static PayoutStatus fromApi(String value) => switch (value) {
    'Paid' => .paid,
    'Next' => .next,
    'Waiting' => .waiting,
    _ => .unknown,
  };

  String get label => switch (this) {
    .paid => 'Paid',
    .next => 'Next to receive',
    .waiting => 'Waiting',
    .unknown => 'Unknown payout status',
  };
}

/// Mirrors one API row. Position, amount and next status belong to the server.
@freezed
abstract class PayoutEntry with _$PayoutEntry {
  const factory({
    required int userId,
    required String memberName,
    required int position,
    required Cents amount,
    required PayoutStatus status,
    DateTime? paidAtUtc,
  }) = _PayoutEntry;
}
