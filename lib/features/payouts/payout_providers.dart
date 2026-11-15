import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/features/payouts/data/fake_payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

/// Composition root: presentation depends on the interface, not this fake.
final Provider<PayoutRepository> payoutRepositoryProvider =
    Provider.autoDispose<PayoutRepository>(
      (ref) => FakePayoutRepository(ref.watch(sessionProvider)),
    );
