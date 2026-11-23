@Tags(['live'])
library;

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';

void main() {
  final address = Platform.environment['RONDI_LIVE_URL'];
  final password = Platform.environment['RONDI_LIVE_PASSWORD'];

  test(
    'live API replays one payment and rejects a stale stokvel edit',
    () async {
      final dio = Dio(BaseOptions(baseUrl: Uri.parse(address!).origin));
      addTearDown(dio.close);
      final credentials = await SessionApi(
        dio,
        'refreshToken',
      ).login(Persona.demo.email, password!);
      dio.options.headers['Authorization'] = 'Bearer ${credentials.access}';
      final api = ApiClient(dio);
      final identity = await api.rest.me.getApiV1Me();
      final id = Random.secure().nextInt(1000000000) + 1000000000;
      await api.saveStokvel(
        id: id,
        name: 'Offline assignment test',
        amount: const Cents(45075),
      );
      await dio.post<void>(
        '/api/v1/contributioncycles',
        data: {'id': id, 'stokvelId': id, 'number': 1, 'targetAmount': 450},
      );
      final original = await api.rest.stokvels.getApiV1StokvelsId(id: id);
      expect(original.contributionAmountCents, 45075);
      final key = 'mobile-assignment113-$id';
      Future<Response<Map<String, dynamic>>> pay() => dio.post(
        '/api/v1/stokvels/$id/cycles/$id/contributions',
        options: Options(headers: {'Idempotency-Key': key}),
        data: {'userId': identity.id, 'amountInCents': 45075},
      );
      final first = await pay();
      final replay = await pay();
      expect(first.statusCode, 201);
      expect(first.headers.value('Idempotency-Replayed'), 'false');
      expect(replay.statusCode, 201);
      expect(replay.headers.value('Idempotency-Replayed'), 'true');
      expect(replay.data, first.data);
      final list = await api.rest.stokvels
          .getApiV1StokvelsStokvelIdContributions(
            stokvelId: id,
            cycleId: id,
            status: 'Paid',
          );
      expect(list.items, hasLength(1));

      await api.saveStokvel(
        id: id,
        name: 'Latest details',
        amount: const Cents(46001),
        version: original.version,
      );
      await expectLater(
        api.saveStokvel(
          id: id,
          name: 'Stale details',
          amount: const Cents(10000),
          version: original.version,
        ),
        throwsA(isA<ConflictFailure>()),
      );
      final latest = await api.rest.stokvels.getApiV1StokvelsId(id: id);
      expect(latest.name, 'Latest details');
      expect(latest.contributionAmountCents, 46001);
    },
    skip: address == null || password == null
        ? 'Requires a disposable development API.'
        : false,
  );
}
