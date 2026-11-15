import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';

void main() {
  test('domain: every API payout status maps, future strings are unknown', () {
    expect(PayoutStatus.fromApi('Paid'), PayoutStatus.paid);
    expect(PayoutStatus.fromApi('Next'), PayoutStatus.next);
    expect(PayoutStatus.fromApi('Waiting'), PayoutStatus.waiting);
    expect(PayoutStatus.fromApi('Reversed'), PayoutStatus.unknown);
    expect(PayoutStatus.fromApi('next'), PayoutStatus.unknown);
    expect(PayoutStatus.values.map((status) => status.label), [
      'Paid',
      'Next to receive',
      'Waiting',
      'Unknown payout status',
    ]);
  });

  test('domain: immutable row preserves server position, cents and date', () {
    final date = DateTime.utc(2026, 11);
    final row = PayoutEntry(
      userId: 2,
      memberName: 'Sipho',
      position: 7,
      amount: const Cents(50010),
      status: .paid,
      paidAtUtc: date,
    );
    expect(row.copyWith(), row);
    expect(row.position, 7);
    expect(formatCents(row.amount), 'R\u00a0500,10');
    expect(row.paidAtUtc, date);
  });
}
