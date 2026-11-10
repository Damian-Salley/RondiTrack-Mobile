import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/stokvel_repository.dart';

/// Provides sample stokvel details without calling the real API.
class FakeStokvelRepository implements StokvelRepository {
  const new(this.persona, {this.delay = const Duration(milliseconds: 600)});

  final Persona persona;
  final Duration delay;

  @override
  Future<StokvelDetail?> fetchDetail(int stokvelId) async {
    // Simulate a network request.
    await Future<void>.delayed(delay);

    // Newcomers and invalid stokvel IDs cannot access these details.
    if (persona == Persona.newcomer || !const {1, 2}.contains(stokvelId)) {
      return null;
    }

    // Select sample data based on the stokvel and persona.
    final community = stokvelId == 1;
    final demo = persona == Persona.demo;

    // Fixture IDs are stable; the backend allocates actual IDs at run time.
    final cycleId = community ? 101 : 201;

    return StokvelDetail(
      stokvel: Stokvel(
        id: stokvelId,
        name: community ? 'Community Savings' : 'Family Savings',
        contributionAmount: Cents(community ? 25000 : 10000),
        memberCount: 2,
      ),
      membership: Membership(
        stokvelId: stokvelId,
        role: demo && community ? .treasurer : .member,
      ),
      callerId: demo ? 1 : 2,

      // Provide an active contribution cycle.
      currentCycle: Cycle(
        id: cycleId,
        stokvelId: stokvelId,
        number: 1,
        status: .active,
        dueDateUtc: DateTime.utc(2026, 11, 30, 22),
        targetAmount: Cents(community ? 50000 : 20000),
        requiredContribution: Cents(community ? 25000 : 10000),
      ),

      // Provide sample contributions for the selected stokvel.
      contributions: [
        Contribution(
          userId: 1,
          stokvelId: stokvelId,
          cycleId: cycleId,
          memberName: 'Demo Member',
          amount: Cents(community ? 25000 : 10000),
          status: community ? .paid : .pending,
          paidAtUtc: community ? DateTime.utc(2026, 10, 31, 22, 30) : null,
        ),
        if (community)
          Contribution(
            userId: 2,
            stokvelId: stokvelId,
            cycleId: cycleId,
            memberName: 'Sample Contributor',
            amount: const Cents(10),
            status: .confirmed,
            paidAtUtc: DateTime.utc(2026, 11),
          ),
      ],
    );
  }
}
