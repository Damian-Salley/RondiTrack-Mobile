import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/offline_refresh.dart';
import 'package:ronditrack_mobile/core/telemetry/analytics.dart';
import 'package:ronditrack_mobile/features/contributions/data/contribution_history.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_api.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox_store.dart';
import 'package:ronditrack_mobile/features/contributions/domain/contribution_page.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';

final paymentOutboxStoreProvider = Provider<PaymentOutboxStore>(
  (ref) => PaymentOutboxStore(ref.watch(offlineDatabaseProvider)),
);

final StreamProvider<List<PaymentIntent>> pendingPaymentsProvider =
    StreamProvider.autoDispose<List<PaymentIntent>>(
      (ref) => ref.watch(paymentOutboxStoreProvider).watch(),
    );

final StreamProvider<PaymentNotice> paymentNoticeProvider =
    StreamProvider.autoDispose<PaymentNotice>(
      (ref) => ref.watch(paymentOutboxSyncProvider).notices,
    );

final paymentOutboxSyncProvider = Provider<PaymentOutboxSync>((ref) {
  final client = ref.watch(apiClientProvider);
  final refresh = ref.watch(offlineRefreshProvider);
  final sync = PaymentOutboxSync(
    ref.watch(paymentOutboxStoreProvider),
    (payment) => sendCyclePayment(client, payment),
    refresh.add,
    analytics: ref.watch(analyticsProvider),
  );
  ref.onDispose(sync.dispose);
  return sync;
});

final contributionHistoryProvider = Provider<ContributionHistory>(
  (ref) => ContributionHistory(ref.watch(apiClientProvider)),
);

final FutureProviderFamily<FilterOptions, int>
contributionFilterOptionsProvider = FutureProvider.autoDispose
    .family<FilterOptions, int>(
      (ref, stokvelId) =>
          ref.watch(contributionHistoryProvider).options(stokvelId),
    );
