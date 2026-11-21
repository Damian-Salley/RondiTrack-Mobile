import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ronditrack_mobile/core/data/generated/models/auth_token_response.dart';
import 'package:ronditrack_mobile/core/data/generated/models/login_request.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';

String extractRefreshCookie(Iterable<String> headers, String name) {
  for (final header in headers) {
    final pair = header.split(';').first.trim();
    final separator = pair.indexOf('=');
    if (separator > 0 && pair.substring(0, separator) == name) {
      final value = pair.substring(separator + 1);
      if (value.isNotEmpty) return value;
    }
  }
  throw const FormatException('Missing refresh cookie.');
}

// Reading claims is for display and expiry only. The API validates the JWT.
Map<String, dynamic> readTokenClaims(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw const FormatException('Invalid access token.');
  return jsonDecode(
    utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
  ) as Map<String, dynamic>;
}

typedef Credentials = ({String access, String refresh, DateTime expiresAt});

class SessionApi {
  new(this._dio, this._cookieName);

  final Dio _dio;
  final String _cookieName;
  static const _path = '/api/v1/auth';

  Future<Credentials> login(String email, String password) => _issue(
    'login',
    data: LoginRequest(email: email, password: password).toJson(),
  );

  Future<void> register(Map<String, String> fields) async {
    await _dio.post<void>('$_path/register', data: fields);
  }

  Future<Credentials> refresh(String token) async {
    try {
      return await _issue('refresh', refresh: token);
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }

  Future<Credentials> _issue(
    String endpoint, {
    Object? data,
    String? refresh,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_path/$endpoint',
      data: data,
      options: refresh == null ? null : _cookieOptions(refresh),
    );
    final body = AuthTokenResponse.fromJson(response.data!);
    final received = DateTime.now().add(
      Duration(seconds: body.expiresIn as int),
    );
    final claims = readTokenClaims(body.accessToken);
    final expires = DateTime.fromMillisecondsSinceEpoch(
      (claims['exp'] as int) * 1000,
    );
    return (
      access: body.accessToken,
      refresh: extractRefreshCookie(
        response.headers['set-cookie'] ?? const [],
        _cookieName,
      ),
      expiresAt: expires.isBefore(received) ? expires : received,
    );
  }

  Future<void> logout(String token) async {
    final cancelToken = CancelToken();
    await _dio
        .post<void>(
          '$_path/logout',
          options: _cookieOptions(token),
          cancelToken: cancelToken,
        )
        .timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            cancelToken.cancel();
            throw StateError('Logout timed out.');
          },
        );
  }

  Options _cookieOptions(String token) =>
      Options(headers: {'Cookie': '$_cookieName=$token'});
}
