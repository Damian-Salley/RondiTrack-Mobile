import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/cache_sync.dart';
import 'package:ronditrack_mobile/core/data/offline_database.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox.dart';
import 'package:ronditrack_mobile/features/contributions/data/payment_outbox_store.dart';
import 'package:ronditrack_mobile/features/contributions/domain/payment_intent.dart';
import 'package:ronditrack_mobile/features/home/data/home_cache.dart';
import 'package:ronditrack_mobile/features/home/domain/home_entry.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/data/stokvel_cache.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

import 'support/session_fixture.dart';

const _membership = Membership(stokvelId: 1, role: StokvelRole.member);
const _home = HomeEntry(
  membership: _membership,
  stokvelName: 'Savings',
  paidThisCycle: Cents(3000),
  stillOwes: Cents(1000),
  arrears: Cents(500),
  totalCollected: Cents(7150),
);
final _detail = StokvelDetail(
  stokvel: const Stokvel(
    id: 1,
    name: 'Savings',
    contributionAmount: Cents(4000),
    memberCount: 2,
  ),
  membership: _membership,
  callerId: 8,
  contributions: const [],
  currentCycle: Cycle(
    id: 11,
    stokvelId: 1,
    number: 2,
    status: CycleStatus.active,
    dueDateUtc: DateTime.utc(2026, 12),
    targetAmount: const Cents(8000),
    requiredContribution: const Cents(4000),
  ),
);
const StokvelCacheKey _detailKey = (stokvelId: 1, cycleId: null);
const PaymentTarget _paymentTarget = (stokvelId: 1, cycleId: 11, userId: 8);
final _initialTime = DateTime.utc(2026, 11);

void main() {
  test(
    'offline startup keeps the known session until a request can refresh it',
    () async {
      final db = OfflineDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final home = HomeCache(db);
      await home.save([_home], _initialTime, db.generation);
      final fixture =
          SessionFixture(
              stored: 'previous-session',
              overrides: [
                offlineStorageEnabledProvider.overrideWithValue(true),
                offlineDatabaseProvider.overrideWithValue(db),
              ],
            )
            ..refreshToken = 'previous-session'
            ..offline = true;
      addTearDown(fixture.dispose);
      await fixture.settled();
      expect(fixture.state, isA<SignedIn>());
      expect(fixture.auth.accessToken(), isNull);
      expect((await home.watch().first)?.data, [_home]);

      await expectLater(fixture.auth.refresh(), throwsA(isA<OfflineFailure>()));
      final requestsWhileOffline = fixture.refreshes;
      fixture.offline = false;
      await fixture.authenticated().get<void>('/resource');
      expect(fixture.auth.accessToken(), isNotNull);
      expect(fixture.refreshes, requestsWhileOffline + 1);
      await fixture.auth.signOut(notifyServer: false);
      expect(fixture.store.value, isNull);
      expect(await home.watch().first, isNull);
    },
  );

  test(
    'Drift watches emit domain data and sign-out clears every table',
    () async {
      final db = OfflineDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final home = HomeCache(db);
      final stokvel = StokvelCache(db);
      final payments = PaymentOutboxStore(db);
      final homeUpdates = StreamIterator(home.watch());
      final detailUpdates = StreamIterator(stokvel.watch(_detailKey));
      addTearDown(homeUpdates.cancel);
      addTearDown(detailUpdates.cancel);

      await Future.wait([homeUpdates.moveNext(), detailUpdates.moveNext()]);
      expect(homeUpdates.current, isNull);
      expect(detailUpdates.current, isNull);
      final generation = db.generation;
      await home.save([_home], _initialTime, generation);
      await stokvel.save(_detailKey, _detail, _initialTime, generation);
      await Future.wait([homeUpdates.moveNext(), detailUpdates.moveNext()]);
      expect(homeUpdates.current?.data, [_home]);
      expect(detailUpdates.current?.data, _detail);
      expect(
        (await stokvel.watch((stokvelId: 1, cycleId: 11)).first)?.data,
        _detail,
      );

      await payments.insert(
        PaymentIntent(
          key: 'pending',
          target: _paymentTarget,
          amount: const Cents(1000),
          createdAt: _initialTime,
        ),
        generation,
      );
      expect((await home.watch().first)?.data.single, _home);
      expect((await payments.read()).single.amount, const Cents(1000));

      await db.clearUserData();
      await Future.wait([homeUpdates.moveNext(), detailUpdates.moveNext()]);
      expect(homeUpdates.current, isNull);
      expect(detailUpdates.current, isNull);
      expect(await payments.read(), isEmpty);
      await home.save([_home], _initialTime, generation);
      expect(await home.watch().first, isNull);
    },
  );

  test(
    'cached detail survives offline, refreshes in Drift, and is evicted on 404',
    () async {
      final db = OfflineDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final cache = StokvelCache(db);
      final generation = db.generation;
      await cache.save(_detailKey, _detail, _initialTime, generation);
      Future<StokvelDetail> Function() response = () async =>
          throw const OfflineFailure();
      final refreshes = StreamController<void>();
      addTearDown(refreshes.close);
      final sync = CacheSync<StokvelDetail>(
        cache: cache.watch(_detailKey),
        fetch: () => response(),
        save: (detail, at) => cache.save(_detailKey, detail, at, generation),
        remove: () => cache.remove(_detailKey, generation),
        refreshes: refreshes.stream,
      );
      addTearDown(sync.dispose);
      final offline = await sync.states.firstWhere(
        (s) => s.failure is OfflineFailure,
      );
      expect(offline.cached?.data, _detail);
      expect(offline.cached?.updatedAt, _initialTime);

      final latest = _detail.copyWith(
        stokvel: _detail.stokvel.copyWith(name: 'Updated'),
      );
      response = () async => latest;
      await sync.refresh();
      final online = await sync.states.firstWhere(
        (s) => !s.refreshing && s.cached?.data == latest,
      );
      expect(online.failure, isNull);
      expect(online.cached!.updatedAt.isAfter(_initialTime), isTrue);

      response = () async => throw const NotFoundFailure();
      await sync.refresh();
      final missing = await sync.states.firstWhere(
        (s) => s.failure is NotFoundFailure,
      );
      expect(missing.cached, isNull);
      expect(await cache.watch(_detailKey).first, isNull);
    },
  );

  test('one payment intent and its key survive an app restart', () async {
    final temp = await Directory.systemTemp.createTemp('ronditrack-outbox-');
    addTearDown(() => temp.delete(recursive: true));
    final databaseFile = File('${temp.path}/cache.sqlite');
    var db = OfflineDatabase(NativeDatabase(databaseFile));
    final initialDb = db;
    var initialDbClosed = false;
    addTearDown(() async {
      if (!initialDbClosed) await initialDb.close();
    });
    var store = PaymentOutboxStore(db);
    final attempts = <String>[];
    var keys = 0;
    var sync = PaymentOutboxSync(
      store,
      (payment) async {
        attempts.add(payment.key);
        throw const OfflineFailure();
      },
      (_) {},
      newKey: () => 'key-${++keys}',
    );
    await Future.wait([
      sync.enqueue(_paymentTarget, const Cents(1000)),
      sync.enqueue(_paymentTarget, const Cents(1000)),
    ]);
    expect(keys, 1);
    expect((await store.read()).single.key, 'key-1');
    expect(attempts, hasLength(1));
    sync.dispose();
    await db.close();
    initialDbClosed = true;

    db = OfflineDatabase(NativeDatabase(databaseFile));
    addTearDown(db.close);
    store = PaymentOutboxStore(db);
    final refreshed = <int>[];
    sync = PaymentOutboxSync(
      store,
      (payment) async => attempts.add(payment.key),
      refreshed.add,
      newKey: () => 'key-${++keys}',
    );
    addTearDown(sync.dispose);
    final paid = sync.notices.first;
    await sync.flush();
    expect((await paid).disposition, PaymentDisposition.paid);
    expect(keys, 1);
    expect(attempts, ['key-1', 'key-1']);
    expect(refreshed, [1]);
    expect(await store.read(), isEmpty);
  });

  test(
    '429 preserves key and wait, a refusal removes it, and expiry never sends',
    () async {
      final db = OfflineDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final store = PaymentOutboxStore(db);
      var now = _initialTime;
      ApiFailure failure = const RateLimitedFailure(60);
      final attempts = <String>[];
      final sync = PaymentOutboxSync(
        store,
        (payment) async {
          attempts.add(payment.key);
          throw failure;
        },
        (_) => fail('Unsuccessful payments must not refresh totals.'),
        now: () => now,
      );
      addTearDown(sync.dispose);
      await sync.enqueue(_paymentTarget, const Cents(1000));
      final queued = (await store.read()).single;
      expect(queued.retryAt, now.add(const Duration(seconds: 60)));
      await sync.flush();
      expect(attempts, [queued.key]);
      now = queued.retryAt!;
      failure = const ConflictFailure(
        'Already paid',
        title: 'Duplicate contribution',
      );
      final refused = sync.notices.first;
      await sync.flush();
      expect((await refused).disposition, PaymentDisposition.refused);
      expect(attempts, [queued.key, queued.key]);
      expect(await store.read(), isEmpty);

      await store.insert(
        PaymentIntent(
          key: 'old',
          target: _paymentTarget,
          amount: const Cents(1000),
          createdAt: now.subtract(PaymentOutboxSync.maximumAge),
        ),
        store.generation,
      );
      final expired = sync.notices.first;
      await sync.flush();
      expect((await expired).disposition, PaymentDisposition.expired);
      expect(attempts, isNot(contains('old')));
      expect(await store.read(), isEmpty);
    },
  );
}
