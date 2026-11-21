@Tags(['live'])
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';
import 'package:ronditrack_mobile/features/session/data/session_dependencies.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

void main() {
  final address = Platform.environment['RONDI_LIVE_URL'];
  final password = Platform.environment['RONDI_LIVE_PASSWORD'];
  final skip = address == null || password == null
      ? 'Set RONDI_LIVE_URL and RONDI_LIVE_PASSWORD for a disposable dev API.'
      : false;
  final cookieName =
      (jsonDecode(File('config/dev.json').readAsStringSync())
              as Map<String, dynamic>)['REFRESH_COOKIE_NAME']
          as String;

  test(
    'fresh seed Home, membership access, close role and wrong address',
    () async {
      ProviderContainer connect(String url) => ProviderContainer.test(
        retry: appRetry,
        overrides: [
          useApiProvider.overrideWithValue(true),
          refreshStoreProvider.overrideWithValue(MemoryRefreshStore()),
          appConfigProvider.overrideWithValue(
            AppConfig.validate(
              flavor: 'dev',
              apiBaseUrl: url,
              nativeFlavor: 'dev',
              refreshCookieName: cookieName,
            ),
          ),
        ],
      );

      final container = connect(address!);
      final auth = container.read(authProvider.notifier);
      await auth.signIn(Persona.demo.email, password!);
      final home = await container.read(homeRepositoryProvider).fetchHome();
      expect(
        home.map((item) => item.membership.role),
        unorderedEquals([StokvelRole.treasurer, StokvelRole.member]),
      );
      for (final item in home) {
        final detail = await container
            .read(stokvelRepositoryProvider)
            .fetchDetail(item.membership.stokvelId);
        expect(detail?.membership, item.membership);
      }
      final family = home.singleWhere(
        (item) => item.membership.role == StokvelRole.member,
      );
      final detail = (await container
          .read(stokvelRepositoryProvider)
          .fetchDetail(family.membership.stokvelId))!;
      await expectLater(
        container.read(
          cycleClosePreviewProvider(
            detail.stokvel.id,
            detail.currentCycle!.id,
          ).future,
        ),
        throwsA(isA<ForbiddenFailure>()),
      );
      expect(container.read(authProvider), isA<SignedIn>());

      await auth.signIn(Persona.contributor.email, password);
      expect(
        await container.read(homeRepositoryProvider).fetchHome(),
        hasLength(2),
      );
      await auth.signIn(Persona.newcomer.email, password);
      expect(await container.read(homeRepositoryProvider).fetchHome(), isEmpty);
      await expectLater(
        container
            .read(stokvelRepositoryProvider)
            .fetchDetail(detail.stokvel.id),
        throwsA(isA<NotFoundFailure>()),
      );
      final unreachable = connect('http://127.0.0.1:1');
      await expectLater(
        unreachable
            .read(authProvider.notifier)
            .signIn(Persona.demo.email, password),
        throwsA(isA<OfflineFailure>()),
      );
    },
    skip: skip,
  );

  test('live rotation, reuse revocation and logout revocation', () async {
    final config = AppConfig.validate(
      flavor: 'dev',
      nativeFlavor: 'dev',
      apiBaseUrl: address!,
      refreshCookieName: cookieName,
    );
    final raw = createDio(config);
    final protected = createDio(config);
    final retry = createDio(config);
    for (final dio in [raw, protected, retry]) {
      addTearDown(() => dio.close(force: true));
    }
    var rotations = 0;
    final loggedOut = Completer<void>();
    raw.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final path = response.requestOptions.uri.path;
          if (path.endsWith('/refresh')) rotations++;
          if (path.endsWith('/logout')) loggedOut.complete();
          handler.next(response);
        },
      ),
    );
    final store = MemoryRefreshStore();
    final api = SessionApi(raw, cookieName);
    final auth = _LiveAuth();
    final container = ProviderContainer.test(
      overrides: [
        useApiProvider.overrideWithValue(true),
        refreshStoreProvider.overrideWithValue(store),
        sessionApiProvider.overrideWithValue(api),
        authProvider.overrideWith(() => auth),
      ],
    );
    await container.read(authProvider.notifier).restore();
    expect(await auth.signIn(Persona.demo.email, password!), isTrue);
    final spent = store.value!;
    auth.spoil();
    final statuses = <String>[];
    protected.interceptors.add(
      SessionInterceptor(auth, retry, log: statuses.add),
    );
    final responses = await Future.wait(
      List.generate(3, (_) => protected.get<dynamic>('/api/v1/me/home')),
    );
    expect(responses.map((response) => response.statusCode), everyElement(200));
    expect(statuses.where((line) => line.contains(' 401 ')), hasLength(3));
    expect(rotations, 1);
    expect(container.read(authProvider), isA<SignedIn>());
    final replacement = store.value!;
    expect(replacement == spent, isFalse);
    await expectLater(api.refresh(spent), throwsA(isA<UnauthorisedFailure>()));
    await expectLater(
      api.refresh(replacement),
      throwsA(isA<UnauthorisedFailure>()),
    );

    await auth.signOut(notifyServer: false);
    expect(await auth.signIn(Persona.demo.email, password), isTrue);
    final beforeLogout = store.value!;
    await auth.signOut();
    expect(store.value, isNull);
    await loggedOut.future.timeout(const Duration(seconds: 3));
    await expectLater(
      api.refresh(beforeLogout),
      throwsA(isA<UnauthorisedFailure>()),
    );
    // Evidence for the PR without exposing authentication headers or bodies.
    stdout
      ..writeln(statuses.join('\n'))
      ..writeln(
        'One refresh, three successful retries, reuse revoked the '
        'replacement, and logout revoked its cookie.',
      );
  }, skip: skip);
}

class _LiveAuth extends Auth {
  bool _spoiled = false;

  void spoil() => _spoiled = true;

  @override
  String? accessToken() =>
      _spoiled ? 'rejected-by-fixture' : super.accessToken();

  @override
  Future<void> refresh() async {
    await super.refresh();
    _spoiled = false;
  }
}
