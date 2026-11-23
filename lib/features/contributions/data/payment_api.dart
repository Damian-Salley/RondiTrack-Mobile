import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/generated/models/record_cycle_contribution_request.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';

Future<void> sendCyclePayment(ApiClient client, PaymentIntent payment) async {
  try {
    await client.rest.stokvels
        .postApiV1StokvelsStokvelIdCyclesCycleIdContributions(
          stokvelId: payment.target.stokvelId,
          cycleId: payment.target.cycleId,
          idempotencyKey: payment.key,
          body: RecordCycleContributionRequest(
            amountInCents: payment.amount.value,
            userId: payment.target.userId,
          ),
        );
  } on Object catch (error) {
    throw mapApiFailure(error);
  }
}
