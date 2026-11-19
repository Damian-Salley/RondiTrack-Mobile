import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/data/generated/rondi_track_client.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';

class ApiPayoutRepository implements PayoutRepository {
  const new(this._client);

  final RondiTrackClient _client;

  @override
  Future<List<PayoutEntry>> fetchOrder(PayoutCycle cycle) async {
    final result = await apiResult(() async {
      final rows = await _client.stokvels
          .getApiV1StokvelsStokvelIdCyclesCycleIdPayouts(
            stokvelId: cycle.stokvelId,
            cycleId: cycle.cycleId,
          );
      // Preserve the rotation and ordering supplied by the backend.
      return [
        for (final row in rows)
          PayoutEntry(
            userId: apiInteger(row.userId),
            memberName: row.memberName,
            position: apiInteger(row.position),
            amount: Cents(apiInteger(row.amountCents)),
            status: PayoutStatus.fromApi(row.status),
            paidAtUtc: row.paidAtUtc?.toUtc(),
          ),
      ];
    });
    return result.unwrap();
  }
}
