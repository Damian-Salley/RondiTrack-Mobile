import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/data/api_client.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';
import 'package:ronditrack_mobile/features/session/data/session_dependencies.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

const cookieName = 'fixtureSession';
const sampleInput = 'typed fixture input';

String jwt(int seconds, [int id = 1]) {
  final claims = jsonEncode({
    'sub': '$id',
    'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + seconds,
  });
  return 'header.${base64Url.encode(utf8.encode(claims))}.unsigned';
}

class SessionFixture {
  new({
    String? stored,
    MemoryRefreshStore? storage,
    List<Override> overrides = const [],
  }) : store = storage ?? MemoryRefreshStore(stored) {
    container = ProviderContainer(
      overrides: [
        useApiProvider.overrideWithValue(true),
        appConfigProvider.overrideWithValue(
          AppConfig.validate(
            flavor: 'dev',
            nativeFlavor: 'dev',
            apiBaseUrl: 'https://fixture.invalid',
            refreshCookieName: cookieName,
          ),
        ),
        refreshStoreProvider.overrideWithValue(store),
        sessionApiProvider.overrideWithValue(SessionApi(client(), cookieName)),
        ...overrides,
      ],
    );
  }

  final MemoryRefreshStore store;
  late final ProviderContainer container;
  final clients = <Dio>[];
  final consumed = <String>{};
  String? refreshToken;
  String? validAccess;
  int loginLifetime = 900;
  int refreshes = 0;
  int logouts = 0;
  int reuses = 0;
  int rejectedAccess = 0;
  int protectedRequests = 0;
  int loginStatus = 200;
  int registerStatus = 201;
  int? refreshStatus;
  bool offline = false;
  final refreshStarted = Completer<void>();
  final logoutStarted = Completer<void>();
  Completer<void>? refreshGate;
  Completer<void>? rejectedRequestGate;

  Auth get auth => container.read(authProvider.notifier);
  AuthState get state => container.read(authProvider);

  Dio client() {
    final dio = Dio(BaseOptions(baseUrl: 'https://fixture.invalid'))
      ..httpClientAdapter = FixtureAdapter(respond);
    clients.add(dio);
    return dio;
  }

  Dio authenticated() =>
      client()
        ..interceptors.add(SessionInterceptor(auth, client(), log: (_) {}));

  Future<void> settled() async {
    while (state is Restoring && !(state as Restoring).failed) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  void dispose() {
    container.dispose();
    for (final client in clients) {
      client.close(force: true);
    }
  }

  Future<ResponseBody> respond(RequestOptions request) async {
    final cookie = request.headers['Cookie'];
    final path = request.uri.path;
    switch (path) {
      case '/api/v1/auth/register':
        return _json(registerStatus, {
          'errors': {
            'phoneNumber': ['Enter a valid phone number.'],
          },
        });
      case '/api/v1/auth/login':
        if (cookie != null) throw StateError('Cookie leaked to login.');
        if (loginStatus != 200) {
          return _json(loginStatus, {}, {
            'retry-after': ['3'],
          });
        }
        consumed.clear();
        return issue('initial', loginLifetime);
      case '/api/v1/auth/refresh':
        refreshes++;
        if (!refreshStarted.isCompleted) refreshStarted.complete();
        final attempt = refreshes;
        await refreshGate?.future;
        if (offline) {
          throw DioException.connectionError(
            requestOptions: request,
            reason: 'fixture offline',
          );
        }
        if (refreshStatus case final status?) return _json(status);
        if (consumed.contains(cookie)) {
          reuses++;
          refreshToken = null;
          return _json(401);
        }
        if (refreshToken == null || cookie != '$cookieName=$refreshToken') {
          return _json(401);
        }
        consumed.add(cookie! as String);
        return issue('rotation-$attempt', 900);
      case '/api/v1/auth/logout':
        logouts++;
        if (!logoutStarted.isCompleted) logoutStarted.complete();
        if (offline) {
          throw DioException.connectionError(
            requestOptions: request,
            reason: 'fixture offline',
          );
        }
        refreshToken = null;
        return _json(204);
      default:
        if (cookie != null) throw StateError('Cookie leaked to a resource.');
        protectedRequests++;
        if (validAccess != null &&
            request.headers['Authorization'] == 'Bearer $validAccess') {
          return _json(200, {'ok': true});
        }
        rejectedAccess++;
        if (rejectedAccess == 3) await rejectedRequestGate?.future;
        return _json(401);
    }
  }

  ResponseBody issue(String token, int seconds) {
    refreshToken = token;
    final access = validAccess = jwt(seconds, refreshes + 1);
    return _json(
      200,
      {'accessToken': access, 'tokenType': 'Bearer', 'expiresIn': seconds},
      {
        'set-cookie': [
          'other=ignored',
          '$cookieName=$token; Path=/api/v1/auth',
        ],
      },
    );
  }
}

ResponseBody _json(
  int status, [
  Map<String, Object?> body = const {},
  Map<String, List<String>> headers = const {},
]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
    ...headers,
  },
);

class FixtureAdapter implements HttpClientAdapter {
  new(this.respond);

  final FutureOr<ResponseBody> Function(RequestOptions) respond;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => await respond(options);

  @override
  void close({bool force = false}) {}
}
