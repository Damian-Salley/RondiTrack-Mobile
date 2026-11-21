import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';
import 'package:ronditrack_mobile/core/state_message.dart';

DioException _response(int status, Object body, {String? wait}) {
  final request = RequestOptions(path: '/api/v1/me/home');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: request,
    response: Response<Object>(
      data: body,
      headers: Headers.fromMap({
        if (wait != null) 'retry-after': [wait],
      }),
      statusCode: status,
      requestOptions: request,
    ),
  );
}

void main() {
  test('maps validation detail and fields from ProblemDetails', () {
    final failure = mapApiFailure(
      _response(400, {
        'detail': 'Check the contribution.',
        'errors': {
          'amount': ['Enter an amount.'],
        },
      }),
    );
    expect(
      failure,
      isA<ValidationFailure>()
          .having((item) => item.message, 'detail', 'Check the contribution.')
          .having((item) => item.fields, 'fields', {
            'amount': ['Enter an amount.'],
          }),
    );
  });

  test('maps API and proxy status responses', () {
    expect(mapApiFailure(_response(401, {})), isA<UnauthorisedFailure>());
    expect(mapApiFailure(_response(403, {})), isA<ForbiddenFailure>());
    expect(mapApiFailure(_response(404, {})), isA<NotFoundFailure>());
    expect(
      mapApiFailure(_response(409, {'detail': 'Changed elsewhere'})),
      isA<ConflictFailure>().having(
        (item) => item.detail,
        'detail',
        'Changed elsewhere',
      ),
    );
    expect(mapApiFailure(_response(410, {})), isA<RuleFailure>());
    expect(
      mapApiFailure(_response(422, {'detail': 'Cycle limit reached'})),
      isA<RuleFailure>().having(
        (item) => item.detail,
        'detail',
        'Cycle limit reached',
      ),
    );
    expect(
      mapApiFailure(_response(429, {}, wait: '43')),
      isA<RateLimitedFailure>().having((item) => item.waitSeconds, 'wait', 43),
    );
    expect(
      mapApiFailure(_response(500, {'correlationId': 'trace-7'})),
      isA<ServerFailure>().having(
        (item) => item.correlationId,
        'reference',
        'trace-7',
      ),
    );
    expect(
      mapApiFailure(_response(502, '<html>Proxy failure</html>')),
      isA<ServerFailure>(),
    );
    expect(mapApiFailure(const FormatException()), isA<ServerFailure>());
    expect(
      mapApiFailure(
        DioException.connectionError(
          requestOptions: RequestOptions(),
          reason: 'unreachable',
        ),
      ),
      isA<OfflineFailure>(),
    );
  });

  test('finds a 404 inside a parallel wait', () async {
    await expectLater(
      (
        Future<void>.error(_response(502, 'proxy')),
        Future<void>.error(_response(404, {})),
      ).wait,
      throwsA(
        predicate<Object>((error) => mapApiFailure(error) is NotFoundFailure),
      ),
    );
  });

  for (final (failure, message, action) in <(ApiFailure, String, String?)>[
    (const NotFoundFailure(), 'Not found', null),
    (const ForbiddenFailure(), 'Your role does not allow this action.', null),
    (
      const RateLimitedFailure(43),
      'Too many requests. Try again in 43 seconds.',
      null,
    ),
    (
      const ServerFailure('trace-7'),
      'Sorry, something went wrong.',
      'Copy reference: trace-7',
    ),
    (
      const OfflineFailure(),
      'You’re offline, or we couldn’t reach the server',
      'Try again',
    ),
  ]) {
    testWidgets('failure screen displays $message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StateMessage(
              message: failure.message,
              apiFailure: failure,
              retry: () {},
            ),
          ),
        ),
      );
      expect(find.text(message), findsOneWidget);
      if (action != null) expect(find.text(action), findsOneWidget);
      if (failure is! OfflineFailure) {
        expect(find.text('Try again'), findsNothing);
      }
    });
  }
}
