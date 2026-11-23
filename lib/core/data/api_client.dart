import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/core/data/generated/rondi_track_client.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/features/session/data/session_dependencies.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

// A plain Provider keeps the transport alive for the provider container.
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = createDio(config);
  final retry = createDio(config);
  dio.interceptors.add(
    SessionInterceptor(ref.read(authProvider.notifier), retry),
  );
  ref.onDispose(() {
    dio.close(force: true);
    retry.close(force: true);
  });
  return ApiClient(dio);
});

/// Keeps the generated Retrofit type inside the data layer.
class ApiClient {
  new(this._dio) : rest = RondiTrackClient(_dio);

  final Dio _dio;
  final RondiTrackClient rest;

  Future<void> saveStokvel({
    required int id,
    required String name,
    required Cents amount,
    String? version,
  }) async {
    // Stringify the decimal token separately to keep the request exact.
    final fields = jsonEncode({'id': id, 'name': name, 'version': ?version});
    final body =
        '${fields.substring(0, fields.length - 1)},'
        '"contributionAmount":${randDecimal(amount)}}';
    try {
      await _dio.request<void>(
        version == null ? '/api/v1/stokvels' : '/api/v1/stokvels/$id',
        data: body,
        options: Options(
          method: version == null ? 'POST' : 'PUT',
          contentType: Headers.jsonContentType,
        ),
      );
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }

  Future<List<({int id, String name})>> stokvelMembers(int stokvelId) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/api/v1/stokvels/$stokvelId/members',
      );
      return [
        for (final member in response.data!.cast<Map<String, Object?>>())
          (
            id: member['id']! as int,
            name: "${member['firstName']} ${member['lastName']}",
          ),
      ];
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }

  Future<int> join(String code) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/invites/${Uri.encodeComponent(code)}/join',
      );
      return response.data!['stokvelId'] as int;
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }
}

class SessionInterceptor extends Interceptor {
  new(this.auth, this.retry, {this.log = developer.log});

  final Auth auth;
  final Dio retry;
  final void Function(String message) log;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.extra['requestTime'] = Stopwatch()..start();
    final generation = auth.generation();
    options.extra['sessionGeneration'] = generation;
    try {
      if (auth.needsRefresh()) await auth.refresh();
      if (generation != auth.generation()) {
        throw DioException.requestCancelled(
          requestOptions: options,
          reason: 'Session changed',
        );
      }
      final value = auth.accessToken();
      if (value != null &&
          options.uri.origin == Uri.parse(options.baseUrl).origin) {
        options.headers['Authorization'] = 'Bearer $value';
      }
      handler.next(options);
    } on Object catch (error) {
      handler.reject(_requestError(error, options));
    }
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.extra['sessionGeneration'] !=
        auth.generation()) {
      handler.reject(
        DioException.requestCancelled(
          requestOptions: response.requestOptions,
          reason: 'Session changed',
        ),
      );
      return;
    }
    _write(response.requestOptions, response.statusCode, null);
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _write(
      err.requestOptions,
      err.response?.statusCode,
      responseCorrelationId(err.response?.data),
    );
    final request = err.requestOptions;
    final generation = request.extra['sessionGeneration'];
    final sent = request.headers['Authorization'];
    if (err.response?.statusCode != 401 ||
        generation != auth.generation() ||
        sent == null) {
      handler.next(err);
      return;
    }
    try {
      // A late 401 belongs to the old token and needs only a replay.
      if (sent == 'Bearer ${auth.accessToken()}') await auth.refresh();
      final access = auth.accessToken();
      if (generation != auth.generation() || access == null) {
        handler.next(err);
        return;
      }
      final options = request.copyWith(
        headers: {...request.headers, 'Authorization': 'Bearer $access'},
      );
      // This client has no session interceptor, so the replay can never loop.
      final response = await retry.fetch<dynamic>(options);
      if (generation != auth.generation()) {
        handler.next(err);
        return;
      }
      _write(options, response.statusCode, null);
      handler.resolve(response);
    } on Object catch (error) {
      handler.reject(_requestError(error, request));
    }
  }

  DioException _requestError(Object error, RequestOptions request) =>
      error is DioException
      ? error
      : DioException(requestOptions: request, error: error);

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
