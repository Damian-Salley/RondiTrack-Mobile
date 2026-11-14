import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout.dart';
import 'package:ronditrack_mobile/features/payouts/domain/payout_repository.dart';
import 'package:ronditrack_mobile/features/payouts/payout_providers.dart';
import 'package:ronditrack_mobile/features/payouts/presentation/payout_provider.dart';

class TestPayoutRepository implements PayoutRepository {
  new(this.load);
  final Future<List<PayoutEntry>> Function(PayoutCycle) load;

  @override
  Future<List<PayoutEntry>> fetchOrder(PayoutCycle cycle) => load(cycle);
}

const testPayout = PayoutEntry(
  userId: 2,
  memberName: 'Server first',
  position: 9,
  amount: Cents(12345),
  status: .next,
);

void main() {
  test('provider: empty is Empty, not Data; loading maps once', () async {
    final result = Completer<List<PayoutEntry>>();
    final container = ProviderContainer(
      retry: appRetry,
      overrides: [
        payoutRepositoryProvider.overrideWithValue(
          TestPayoutRepository((_) => result.future),
        ),
      ],
    );
    addTearDown(container.dispose);
    const cycle = (stokvelId: 2, cycleId: 201);
    final states = <ViewState<List<PayoutEntry>>>[];
    container.listen(
      payoutViewProvider(cycle),
      (_, value) => states.add(value),
      fireImmediately: true,
    );
    expect(states.single, isA<Loading<List<PayoutEntry>>>());
    result.complete([]);
    await container.read(payoutsProvider(cycle).future);
    await container.pump();
    expect(states, hasLength(2));
    expect(states.last, isA<Empty<List<PayoutEntry>>>());
  });

  test(
    'provider: two value-keyed cycles keep data and failure separate',
    () async {
      final first = Completer<List<PayoutEntry>>();
      final second = Completer<List<PayoutEntry>>();
      final container = ProviderContainer(
        retry: appRetry,
        overrides: [
          payoutRepositoryProvider.overrideWithValue(
            TestPayoutRepository(
              (cycle) => cycle.cycleId == 101 ? first.future : second.future,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      const a = (stokvelId: 1, cycleId: 101);
      const b = (stokvelId: 2, cycleId: 201);
      final statesA = <ViewState<List<PayoutEntry>>>[];
      final statesB = <ViewState<List<PayoutEntry>>>[];
      container
        ..listen(
          payoutViewProvider(a),
          (_, state) => statesA.add(state),
          fireImmediately: true,
        )
        ..listen(
          payoutViewProvider(b),
          (_, state) => statesB.add(state),
          fireImmediately: true,
        );
      first.complete([testPayout]);
      await container.read(payoutsProvider(a).future);
      await container.pump();
      expect(statesA.last, isA<Data<List<PayoutEntry>>>());
      expect(statesB.single, isA<Loading<List<PayoutEntry>>>());
      second.completeError(StateError('offline'));
      await expectLater(
        container.read(payoutsProvider(b).future),
        throwsStateError,
      );
      await container.pump();
      expect(statesA, hasLength(2));
      expect(statesB, hasLength(2));
      expect(statesB.last, isA<Failure<List<PayoutEntry>>>());
      expect((statesA.last as Data<List<PayoutEntry>>).value, [testPayout]);
    },
  );

  test(
    'provider: not found is immediate and never automatically retried',
    () async {
      var calls = 0;
      final container = ProviderContainer(
        retry: appRetry,
        overrides: [
          payoutRepositoryProvider.overrideWithValue(
            TestPayoutRepository((_) async {
              calls++;
              throw const PayoutNotFound();
            }),
          ),
        ],
      );
      addTearDown(container.dispose);
      const cycle = (stokvelId: 1, cycleId: 101);
      container.listen(payoutViewProvider(cycle), (_, _) {});
      await expectLater(
        container.read(payoutsProvider(cycle).future),
        throwsA(isA<PayoutNotFound>()),
      );
      await container.pump();
      expect(
        (container.read(
          payoutViewProvider(cycle),
        ) as Failure<List<PayoutEntry>>).message,
        'Cycle not found.',
      );
      expect(calls, 1);
      expect(appRetry(0, const PayoutNotFound()), isNull);
    },
  );
}
