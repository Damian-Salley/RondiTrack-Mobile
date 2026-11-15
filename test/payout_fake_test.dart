import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';

void main() {
  for (final persona in Persona.values) {
    final repository = FakePayoutRepository(persona, delay: Duration.zero);
    test('fake: $persona membership and exact seeded order', () async {
      const cycle = (stokvelId: 1, cycleId: 101);
      if (persona == Persona.newcomer) {
        await expectLater(
          repository.fetchOrder(cycle),
          throwsA(isA<PayoutNotFound>()),
        );
      } else {
        final order = await repository.fetchOrder(cycle);
        expect(order.map((row) => row.userId), [1, 2]);
        expect(order.map((row) => row.position), [1, 2]);
        expect(order.map((row) => row.amount.value), [50000, 50000]);
        expect(order.map((row) => row.status), [
          PayoutStatus.next,
          PayoutStatus.waiting,
        ]);
        expect(
          await repository.fetchOrder((stokvelId: 2, cycleId: 201)),
          isEmpty,
        );
      }
    });
    test(
      'fake: $persona cannot address missing or mismatched cycles',
      () async {
        for (final cycle in [
          (stokvelId: 1, cycleId: 201),
          (stokvelId: 999, cycleId: 101),
          (stokvelId: 1, cycleId: 999),
        ]) {
          await expectLater(
            repository.fetchOrder(cycle),
            throwsA(isA<PayoutNotFound>()),
          );
        }
      },
    );
  }
}
