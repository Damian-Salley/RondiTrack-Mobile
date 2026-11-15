import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/payout_providers.dart';

final FutureProviderFamily<List<PayoutEntry>, PayoutCycle> payoutsProvider =
    FutureProvider.autoDispose.family<List<PayoutEntry>, PayoutCycle>(
      (ref, cycle) => ref.watch(payoutRepositoryProvider).fetchOrder(cycle),
    );

final ProviderFamily<ViewState<List<PayoutEntry>>, PayoutCycle>
payoutViewProvider = Provider.autoDispose
    .family<ViewState<List<PayoutEntry>>, PayoutCycle>((ref, cycle) {
      final result = ref.watch(payoutsProvider(cycle));
      if (!result.isLoading && result.error is PayoutNotFound) {
        return const Failure('Cycle not found.');
      }
      return toViewState(result, isEmpty: (order) => order.isEmpty);
    });
