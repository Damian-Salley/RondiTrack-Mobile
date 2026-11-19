import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/core/data/generated/rondi_track_client.dart';
import 'package:ronditrack_mobile/features/home/data/api_home_repository.dart';
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
      final home = await ApiHomeRepository(RondiTrackClient(dio)).fetchHome();
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
