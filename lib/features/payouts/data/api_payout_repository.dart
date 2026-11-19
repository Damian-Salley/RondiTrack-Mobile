import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/api_result.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/result.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';

class ApiPayoutRepository implements PayoutRepository {
  const new(this._client);

  final ApiClient _client;

  @override
  Future<List<PayoutEntry>> fetchOrder(PayoutCycle cycle) async =>
      (await readOrder(cycle)).unwrap();

  /// Reads the server-owned order as a value or a typed failure.
  Future<Result<List<PayoutEntry>>> readOrder(PayoutCycle cycle) =>
      apiResult(() async {
        final rows = await _client.rest.stokvels
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
}
