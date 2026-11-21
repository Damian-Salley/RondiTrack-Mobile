import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/payouts/data/api_payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

/// Composition root: presentation depends on the interface, not this fake.
final Provider<PayoutRepository> payoutRepositoryProvider =
    Provider.autoDispose<PayoutRepository>((ref) {
      if (ref.watch(useApiProvider)) {
        ref.watch(authProvider);
        return ApiPayoutRepository(ref.watch(apiClientProvider));
      }
      return FakePayoutRepository(ref.watch(sessionProvider));
    });
