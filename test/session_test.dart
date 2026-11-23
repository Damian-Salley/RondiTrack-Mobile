import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';
import 'package:ronditrack_mobile/features/session/data/session_dependencies.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

import 'support/session_fixture.dart';

void main() {
  test('cookie extraction uses the configured name and requires a value', () {
    expect(
      extractRefreshCookie([
        'similarFixtureSession=wrong',
        '$cookieName=abc==; expires=Sat, 28 Nov 2026 12:00:00 GMT',
      ], cookieName),
      'abc==',
    );
    expect(
      () => extractRefreshCookie(['other=token'], cookieName),
      throwsFormatException,
    );
    expect(
      () => extractRefreshCookie(['$cookieName='], cookieName),
      throwsFormatException,
    );
    expect(readTokenClaims(jwt(900, 12))['sub'], '12');
  });

  Future<SessionFixture> signedIn({int expiresIn = 900}) async {
    final fixture = SessionFixture()..loginLifetime = expiresIn;
    addTearDown(fixture.dispose);
    await fixture.settled();
    expect(
      await fixture.auth.signIn('fixture@example.invalid', sampleInput),
      isTrue,
    );
    return fixture;
  }

  test('three expired requests share one rotation and all succeed', () async {
    final fixture = await signedIn(expiresIn: -1);
    fixture.refreshGate = Completer<void>();
    final dio = fixture.authenticated();
    final requests = Future.wait(
      List.generate(3, (_) => dio.get<void>('/resource')),
    );
    await Future<void>.delayed(Duration.zero);
    fixture.refreshGate!.complete();
    expect(await requests, hasLength(3));
    expect(fixture.refreshes, 1);
    expect(fixture.reuses, 0);
    expect(fixture.rejectedAccess, 0);
    expect(fixture.state, isA<SignedIn>());
  });

  test(
    'simultaneous and late 401 responses reuse the one replacement',
    () async {
      final fixture = (await signedIn())
        ..validAccess = null
        ..refreshGate = Completer<void>()
        ..rejectedRequestGate = Completer<void>();
      final dio = fixture.authenticated();
      final requests = Future.wait(
        List.generate(3, (_) => dio.get<void>('/resource')),
      );
      while (fixture.rejectedAccess < 3 || fixture.refreshes == 0) {
        await Future<void>.delayed(Duration.zero);
      }
      fixture.refreshGate!.complete();
      while (fixture.protectedRequests < 5) {
        await Future<void>.delayed(Duration.zero);
      }
      fixture.rejectedRequestGate!.complete();
      expect(await requests, hasLength(3));
      expect(fixture.refreshes, 1);
      expect(fixture.reuses, 0);
      expect(fixture.state, isA<SignedIn>());
    },
  );

  test(
    'broken per-401 interceptor reuses a spent cookie and ends the session',
    () async {
      final fixture = (await signedIn())
        ..validAccess = null
        ..refreshGate = Completer<void>();
      final refresh = SessionApi(fixture.client(), cookieName);
      final retry = fixture.client();
      final spent = fixture.store.value!;
      final dio = fixture.client()
        ..interceptors.add(
          InterceptorsWrapper(
            onError: (error, handler) async {
              // Deliberately rotate the same cookie for every 401.
              try {
                final replacement = await refresh.refresh(spent);
                handler.resolve(
                  await retry.get<void>(
                    '/resource',
                    options: Options(
                      headers: {
                        'Authorization': 'Bearer ${replacement.access}',
                      },
                    ),
                  ),
                );
              } on UnauthorisedFailure {
                await fixture.auth.signOut(notifyServer: false);
                handler.next(error);
              }
            },
          ),
        );
      final result = Future.wait(
        List.generate(3, (_) async {
          try {
            await dio.get<void>('/resource');
            return true;
          } on DioException {
            return false;
          }
        }),
      );
      while (fixture.refreshes < 3) {
        await Future<void>.delayed(Duration.zero);
      }
      fixture.refreshGate!.complete();
      expect(await result, contains(false));
      expect(fixture.reuses, 2);
      expect(fixture.state, isA<SignedOut>());
      expect(fixture.store.value, isNull);
    },
  );

  test(
    'a nearly expired token refreshes before the first resource request',
    () async {
      final fixture = await signedIn(expiresIn: 10);
      await fixture.authenticated().get<void>('/resource');
      expect(fixture.refreshes, 1);
      expect(fixture.protectedRequests, 1);
      expect(fixture.rejectedAccess, 0);
    },
  );

  for (final status in [401, 403, 429, 500, null]) {
    test(
      'refresh failure ${status ?? 'offline'} has the correct session effect',
      () async {
        final fixture = (await signedIn(expiresIn: -1))
          ..refreshStatus = status
          ..offline = status == null;
        var ended = 0;
        fixture.container.listen(authProvider, (_, next) {
          if (next is SignedOut) ended++;
        });
        final dio = fixture.authenticated();
        await Future.wait(
          List.generate(
            3,
            (_) => expectLater(
              dio.get<void>('/resource'),
              throwsA(isA<DioException>()),
            ),
          ),
        );
        expect(fixture.refreshes, 1);
        expect(ended, status == 401 ? 1 : 0);
        expect(fixture.store.value, status == 401 ? isNull : 'initial');
        expect(
          fixture.state,
          status == 401 ? isA<SignedOut>() : isA<SignedIn>(),
        );
      },
    );
  }

  for (final scenario in ['valid', 'refused', 'empty', 'offline']) {
    test('restore with $scenario storage', () async {
      final fixture =
          SessionFixture(stored: scenario == 'empty' ? null : 'saved')
            ..refreshToken = scenario == 'refused' ? 'different' : 'saved'
            ..offline = scenario == 'offline';
      addTearDown(fixture.dispose);
      expect(fixture.state, isA<Restoring>());
      await fixture.settled();
      expect(fixture.refreshes, scenario == 'empty' ? 0 : 1);
      switch (scenario) {
        case 'valid':
          expect(fixture.state, isA<SignedIn>());
          expect(fixture.store.value, 'rotation-1');
        case 'offline':
          expect(
            fixture.state,
            isA<Restoring>().having((state) => state.failed, 'failed', true),
          );
          expect(fixture.store.value, 'saved');
          fixture.offline = false;
          await fixture.auth.restore();
          expect(fixture.state, isA<SignedIn>());
        default:
          expect(fixture.state, isA<SignedOut>());
          expect(fixture.store.value, isNull);
      }
    });
  }

  for (final offline in [false, true]) {
    test(
      'sign-in persists the token and sign-out wipes it (offline=$offline)',
      () async {
        final fixture = await signedIn();
        expect(fixture.store.value, 'initial');
        fixture.offline = offline;
        final signOut = fixture.auth.signOut();
        expect(fixture.auth.accessToken(), isNull);
        await signOut;
        expect(fixture.state, isA<SignedOut>());
        expect(fixture.store.value, isNull);
        await fixture.logoutStarted.future;
        expect(fixture.logouts, 1);
      },
    );
  }

  test(
    'a refresh finishing after sign-out cannot restore either token',
    () async {
      final fixture = await signedIn();
      fixture.refreshGate = Completer<void>();
      final refresh = fixture.auth.refresh();
      await fixture.refreshStarted.future;
      expect(fixture.refreshes, 1);
      await fixture.auth.signOut(notifyServer: false);
      fixture.refreshGate!.complete();
      await refresh;
      expect(fixture.auth.accessToken(), isNull);
      expect(fixture.store.value, isNull);
      expect(fixture.state, isA<SignedOut>());
    },
  );

  test(
    'sign-out completes only after the secure entry has been deleted',
    () async {
      final store = _SlowWipe();
      final fixture = SessionFixture(storage: store);
      addTearDown(fixture.dispose);
      await fixture.settled();
      expect(
        await fixture.auth.signIn('fixture@example.invalid', sampleInput),
        isTrue,
      );
      final signOut = fixture.auth.signOut();
      await store.started.future;
      expect(fixture.auth.accessToken(), isNull);
      expect(fixture.state, isA<SignedIn>());
      expect(fixture.logouts, 0);
      store.allowWipe.complete();
      await signOut;
      expect(fixture.state, isA<SignedOut>());
      expect(store.value, isNull);
    },
  );
}

class _SlowWipe extends MemoryRefreshStore {
  final started = Completer<void>();
  final allowWipe = Completer<void>();

  @override
  Future<void> write(String? value) async {
    if (value == null) {
      started.complete();
      await allowWipe.future;
    }
    await super.write(value);
  }
}
