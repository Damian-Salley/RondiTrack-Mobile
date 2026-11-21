import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';

abstract interface class RefreshStore {
  Future<String?> read();
  Future<void> write(String? value);
}

class SecureRefreshStore implements RefreshStore {
  const new(this.namespace);

  final String namespace;
  static const _storage = FlutterSecureStorage();
  String get _key => 'session.$namespace';

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String? value) => value == null
      ? _storage.delete(key: _key)
      : _storage.write(key: _key, value: value);
}

class MemoryRefreshStore implements RefreshStore {
  new([this.value]);

  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String? value) async => this.value = value;
}

Dio createDio(AppConfig config) => Dio(
  BaseOptions(
    baseUrl: config.apiBaseUrl.resolve('/').toString(),
    connectTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 25),
    followRedirects: false,
  ),
);

final refreshStoreProvider = Provider<RefreshStore>((ref) {
  final config = ref.watch(appConfigProvider);
  return SecureRefreshStore(config.flavor);
});

final sessionApiProvider = Provider<SessionApi>((ref) {
  final config = ref.watch(appConfigProvider);
  final dio = createDio(config);
  ref.onDispose(() => dio.close(force: true));
  return SessionApi(dio, config.refreshCookieName);
});
