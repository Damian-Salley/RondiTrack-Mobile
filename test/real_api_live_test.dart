@Tags(['live'])
library;

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/provider_retry.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/home/home_providers.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

void main() {
  final address = Platform.environment['RONDI_LIVE_URL'];
  final password = Platform.environment['RONDI_LIVE_PASSWORD'];

  test(
    'fresh seed Home, membership access, close role and wrong address',
    () async {
      ProviderContainer connect(String url) => ProviderContainer.test(
        retry: appRetry,
        overrides: [
          useApiProvider.overrideWithValue(true),
          seedPasswordProvider.overrideWithValue(password!),
          appConfigProvider.overrideWithValue(
            AppConfig.validate(
              flavor: 'dev',
              apiBaseUrl: url,
              nativeFlavor: 'dev',
            ),
          ),
        ],
      );

      final container = connect(address!);
      final auth = container.read(authProvider.notifier);
      await auth.signIn(Persona.demo.email);
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
      expect(container.read(authProvider), Persona.demo);

      await auth.signIn(Persona.contributor.email);
      expect(
        await container.read(homeRepositoryProvider).fetchHome(),
        hasLength(2),
      );
      await auth.signIn(Persona.newcomer.email);
      expect(await container.read(homeRepositoryProvider).fetchHome(), isEmpty);
      await expectLater(
        container
            .read(stokvelRepositoryProvider)
            .fetchDetail(detail.stokvel.id),
        throwsA(isA<NotFoundFailure>()),
      );
      final unreachable = connect('http://127.0.0.1:1');
      await expectLater(
        unreachable.read(authProvider.notifier).signIn(Persona.demo.email),
        throwsA(isA<OfflineFailure>()),
      );
    },
    skip: address == null || password == null
        ? 'Set RONDI_LIVE_URL and RONDI_LIVE_PASSWORD for a fresh dev seed.'
        : false,
  );
}
