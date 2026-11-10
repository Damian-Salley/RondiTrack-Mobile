import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/home/domain/home_repository.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';

/// Provides sample Home screen data without connecting to the real API.
class FakeHomeRepository implements HomeRepository {
  const new(this.persona, {this.delay = const Duration(milliseconds: 350)});

  final Persona persona;
  final Duration delay;

  @override
  Future<List<HomeEntry>> fetchHome() async {
    // Simulate the delay of a real network request.
    await Future<void>.delayed(delay);

    // The new member has no stokvel memberships.
    if (persona == Persona.newcomer) return [];

    // The demo persona is Treasurer in the first stokvel.
    final demo = persona == Persona.demo;

    return [
      HomeEntry(
        membership: Membership(stokvelId: 1, role: demo ? .treasurer : .member),
        stokvelName: 'Community Savings',

        // Store all financial amounts as whole cents.
        paidThisCycle: Cents(demo ? 25000 : 10),
        stillOwes: Cents(demo ? 0 : 24990),
        arrears: Cents(demo ? 0 : 25000),
        totalCollected: const Cents(25010),
        currentCycle: 1,
        cycleStatus: .active,
      ),

      // Both existing personas are ordinary members of this stokvel.
      const HomeEntry(
        membership: Membership(stokvelId: 2, role: .member),
        stokvelName: 'Family Savings',
        paidThisCycle: Cents(0),
        stillOwes: Cents(10000),
        arrears: Cents(0),
        totalCollected: Cents(0),
        currentCycle: 1,
        cycleStatus: .active,
      ),
    ];
  }
}
