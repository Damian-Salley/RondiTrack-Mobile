import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/core/data/generated/rondi_track_client.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';

/// Holds the token for this app process and can be cleared on sign-out.
final accessTokenProvider = Provider<AccessToken>((ref) => AccessToken());

class AccessToken {
  String? value;
}

// A plain Provider keeps the transport alive for the provider container.
final apiClientProvider = Provider<RondiTrackClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = Dio(
    BaseOptions(
      // Generated routes already contain the API version prefix.
      baseUrl: config.apiBaseUrl.resolve('/').toString(),
      connectTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 25),
      followRedirects: false,
    ),
  );
  dio.interceptors.add(ApiInterceptor(ref.watch(accessTokenProvider)));
  ref.onDispose(() => dio.close(force: true));
  return RondiTrackClient(dio);
});

class ApiInterceptor extends Interceptor {
  new(this.token, {this.log = developer.log});

  final AccessToken token;
  final void Function(String message) log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['requestTime'] = Stopwatch()..start();
    if (token.value case final String value) {
      options.headers['Authorization'] = 'Bearer $value';
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _write(response.requestOptions, response.statusCode, null);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _write(
      err.requestOptions,
      err.response?.statusCode,
      responseCorrelationId(err.response?.data),
    );
    handler.next(err);
  }

  void _write(RequestOptions options, int? status, String? correlationId) {
    final elapsed = options.extra['requestTime'] as Stopwatch?;
    // Only route literals reach logs. Replace IDs and other dynamic segments.
    final path = options.uri.pathSegments
        .map((segment) {
          const literals = {
            'api',
            'v1',
            'auth',
            'login',
            'me',
            'home',
            'activity',
            'stokvels',
            'cycles',
            'contributioncycles',
            'contributions',
            'close-preview',
            'payouts',
          };
          return literals.contains(segment) ? segment : ':value';
        })
        .join('/');
    final reference =
        correlationId != null &&
            RegExp(r'^[A-Za-z0-9:_-]{1,100}$').hasMatch(correlationId)
        ? ' correlationId=$correlationId'
        : '';
    log(
      '${options.method} /$path ${status ?? '-'} ${elapsed?.elapsedMilliseconds ?? 0}ms$reference',
    );
  }
}
