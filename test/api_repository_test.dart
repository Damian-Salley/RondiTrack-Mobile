import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/home/data/api_home_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/data/api_stokvel_repository.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/models.dart';
import 'package:ronditrack_mobile/features/stokvels/domain/status.dart';

class _FakeAdapter implements HttpClientAdapter {
  new(this.respond);

  final ResponseBody Function(RequestOptions) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => respond(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(String value, int status) => ResponseBody.fromString(
  value,
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  test(
    'detail follows the page token and keeps SA date and close version',
    () async {
      final dio = Dio();
      addTearDown(dio.close);
      const token = 'opaque+/=';
      final tokens = <Object?>[];
      dio.httpClientAdapter = _FakeAdapter((request) {
        switch (request.path) {
          case '/api/v1/stokvels/1':
            return _json('''
            {"id":1,"name":"Community Savings","contributionAmount":250,
            "contributionAmountCents":25000,"memberCount":2}
            ''', 200);
          case '/api/v1/me':
            return _json('''
            {"id":2,"firstName":"Demo","lastName":"Member",
            "email":"assignment71-demo@ronditrack.example"}
            ''', 200);
          case '/api/v1/me/home':
            return _json('''
            [{"stokvelId":1,"stokvelName":"Community Savings","role":"Treasurer",
            "currentCycle":1,"cycleStatus":"Active","paidThisCycle":25000,
            "totalCollectedCents":"25010","stillOwes":0,"arrearsCents":0}]
            ''', 200);
          case '/api/v1/contributioncycles':
            return _json('''
            [{"id":8,"stokvelId":1,"number":1,"status":"Active",
            "dueDateUtc":"2026-11-30T22:00:00Z","targetAmountCents":50000,
            "requiredContributionCents":25000}]
            ''', 200);
          case '/api/v1/stokvels/1/cycles/8/contributions':
            final next = request.queryParameters['PageToken'];
            tokens.add(next);
            if (next == null) {
              return _json('''
              {"items":[{"userId":2,"stokvelId":1,"cycle":8,"amountCents":25000,
              "status":"Paid","memberName":"Demo Member"}],"nextPageToken":"$token"}
              ''', 200);
            }
            return _json('''
            {"items":[{"userId":3,"stokvelId":1,"cycle":8,"amountCents":10,
            "status":"Confirmed","memberName":"Sample Contributor"}],
            "nextPageToken":null}
            ''', 200);
          case '/api/v1/contributioncycles/8/close-preview':
            return _json('''
            {"cycleId":8,"cycleName":"Cycle 1","asOfDate":"2026-12-01",
            "version":"Opaque-Version","members":[],"totalCents":25010}
            ''', 200);
          default:
            throw StateError('Unexpected request route');
        }
      });
      final client = ApiClient(dio);
      final repository = ApiStokvelRepository(
        client,
        ApiHomeRepository(client),
      );
      final detail = (await repository.fetchDetail(1))!;
      expect(tokens, [null, token]);
      expect(detail.currentCycle!.southAfricanDueDate, '2026-12-01');
      expect(detail.currentCycle!.dueDateUtc.isUtc, isTrue);
      expect(detail.contributions.map((item) => item.amount.value), [
        25000,
        10,
      ]);
      final preview = await repository.previewClose(1, 8);
      expect(preview.version, 'Opaque-Version');
      expect(preview.total.value, 25010);
      await expectLater(
        repository.fetchDetail(1, cycleId: 999),
        throwsA(isA<NotFoundFailure>()),
      );
      expect(tokens, [null, token]);
    },
  );

  test(
    'generated Home response preserves role, cents and unknown statuses',
    () async {
      final dio = Dio();
      addTearDown(dio.close);
      // Home DTO values match the development seed. A new status models a
      // future server release with an unchanged string field.
      dio.httpClientAdapter = _FakeAdapter((request) {
        expect(request.path, '/api/v1/me/home');
        return _json('''
        [{
          "stokvelId": 1,
          "stokvelName": "Community Savings",
          "role": "Treasurer",
          "currentCycle": 1,
          "cycleStatus": "FutureStatus",
          "paidThisCycle": 25000,
          "totalCollectedCents": "25010",
          "stillOwes": 0,
          "arrearsCents": 0,
          "nextPayoutDate": "2026-11-30T22:00:00Z"
        }]
        ''', 200);
      });
      final home = await ApiHomeRepository(ApiClient(dio)).fetchHome();
      final entry = home.single;
      expect(entry.membership.role, StokvelRole.treasurer);
      expect(entry.totalCollected.value, 25010);
      expect(entry.cycleStatus, CycleStatus.unknown);
      expect(entry.nextPayoutDate!.isUtc, isTrue);
    },
  );

  test(
    'transport logs exclude private values and a 403 retains token',
    () async {
      final dio = Dio();
      addTearDown(dio.close);
      final logs = <String>[];
      final token = AccessToken()..value = 'private-token';
      dio.interceptors.add(ApiInterceptor(token, log: logs.add));
      dio.httpClientAdapter = _FakeAdapter((request) {
        expect(request.headers['Authorization'], 'Bearer private-token');
        return _json(
          '{"correlationId":"trace-1","detail":"Lerato owes 25000"}',
          403,
        );
      });
      for (var i = 0; i < 2; i++) {
        await expectLater(
          dio.post<void>(
            '/api/v1/stokvels/77',
            data: {'name': 'Lerato', 'arrears': 25000},
            queryParameters: {'search': 'private-query'},
            options: Options(headers: {'Cookie': 'private-cookie'}),
          ),
          throwsA(isA<DioException>()),
        );
      }
      expect(token.value, 'private-token');
      expect(logs, hasLength(2));
      for (final line in logs) {
        expect(
          line,
          matches(
            r'^POST /api/v1/stokvels/:value 403 \d+ms correlationId=trace-1$',
          ),
        );
        for (final value in [
          'private-token',
          'private-cookie',
          'private-query',
          'Lerato',
          '25000',
        ]) {
          expect(line, isNot(contains(value)));
        }
      }
    },
  );
}
