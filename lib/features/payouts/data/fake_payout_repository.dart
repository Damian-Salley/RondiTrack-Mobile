import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/data/fake_stokvel_repository.dart';

class FakePayoutRepository implements PayoutRepository {
  const new(this.persona, {this.delay = const Duration(milliseconds: 600)});

  final Persona persona;
  final Duration delay;

  @override
  Future<List<PayoutEntry>> fetchOrder(PayoutCycle cycle) async {
    await Future<void>.delayed(delay);
    // Reuse the existing fake's memberships; do not create a second role table.
    final detail = await FakeStokvelRepository(
      persona,
      delay: Duration.zero,
    ).fetchDetail(cycle.stokvelId);
    if (detail == null || detail.currentCycle?.id != cycle.cycleId) {
      throw const PayoutNotFound();
    }
    // Family's known cycle has no order yet. Empty is different from not found.
    if (cycle.stokvelId == 2) return [];

    // These are literal server-response fixtures, never calculated in the app.
    return const [
      PayoutEntry(
        userId: 1,
        memberName: 'Demo Member',
        position: 1,
        amount: Cents(50000),
        status: .next,
      ),
      PayoutEntry(
        userId: 2,
        memberName: 'Sample Contributor',
        position: 2,
        amount: Cents(50000),
        status: .waiting,
      ),
    ];
  }
}
