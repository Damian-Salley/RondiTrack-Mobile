import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/data/map_api_failure.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';
import 'package:ronditrack_mobile/features/session/data/session_dependencies.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

sealed class AuthState {
  const new();
}

final class SignedOut extends AuthState {
  const new();
}

final class SignedIn extends AuthState {
  const new(this.label);

  final String label;
}

final class Restoring extends AuthState {
  const new({this.failed = false});

  final bool failed;
}

final authProvider = NotifierProvider<Auth, AuthState>(Auth.new);

class Auth extends Notifier<AuthState> {
  static const refreshMargin = Duration(seconds: 30);

  Credentials? _credentials;
  String? _refreshToken;
  Future<void>? _refreshing;
  Future<void>? _signingOut;
  Future<void> _storage = Future.value();
  int _generation = 0;

  String? accessToken() => _credentials?.access;
  int generation() => _generation;
  bool needsRefresh() =>
      _credentials?.expiresAt.isBefore(DateTime.now().add(refreshMargin)) ??
      false;

  @override
  AuthState build() {
    if (!ref.read(useApiProvider)) return const SignedOut();
    unawaited(
      Future<void>.microtask(() {
        if (ref.mounted && state is Restoring) return restore();
      }),
    );
    return const Restoring();
  }

  FutureOr<bool> signIn(String email, [String password = '']) {
    if (_signingOut != null) return false;
    final address = email.trim();
    if (ref.read(useApiProvider)) return _login(address, password);
    final persona = Persona.values
        .where((person) => person.email == address.toLowerCase())
        .firstOrNull;
    if (persona == null) return false;
    ref.read(sessionProvider.notifier).select(persona);
    state = SignedIn(persona.label);
    return true;
  }

  Future<bool> _login(String email, String password) async {
    final generation = ++_generation;
    try {
      final credentials = await ref
          .read(sessionApiProvider)
          .login(email, password);
      if (!await _accept(credentials, generation)) return false;
      state = SignedIn(email);
      return true;
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }

  Future<void> register(Map<String, String> fields) async {
    try {
      await ref.read(sessionApiProvider).register(fields);
    } on Object catch (error) {
      throw mapApiFailure(error);
    }
  }

  Future<void> restore() async {
    if (state is! Restoring || _signingOut != null) return;
    state = const Restoring();
    final generation = _generation;
    try {
      await refresh();
      if (!_current(generation)) return;
      state = _credentials == null
          ? const SignedOut()
          : const SignedIn('Signed in');
    } on Object {
      if (_current(generation)) state = const Restoring(failed: true);
    }
  }

  // Share the same future, including its failure, among all refresh callers.
  Future<void> refresh() {
    if (_signingOut != null) return Future.value();
    if (_refreshing case final active?) return active;
    final operation = _refresh(_generation);
    _refreshing = operation;
    return operation.whenComplete(() {
      if (identical(_refreshing, operation)) _refreshing = null;
    });
  }

  Future<void> _refresh(int generation) async {
    final store = ref.read(refreshStoreProvider);
    final api = ref.read(sessionApiProvider);
    final token = _refreshToken ?? await store.read();
    if (!_current(generation) || token == null) return;
    _refreshToken = token;
    try {
      final credentials = await api.refresh(token);
      await _accept(credentials, generation);
    } on UnauthorisedFailure {
      if (_current(generation)) {
        await signOut(notifyServer: false);
      }
      rethrow;
    }
  }

  bool _current(int generation) => ref.mounted && generation == _generation;

  Future<bool> _accept(Credentials credentials, int generation) async {
    if (!_current(generation)) return false;
    _refreshToken = credentials.refresh;
    final store = ref.read(refreshStoreProvider);
    await _write(() async {
      if (_current(generation)) await store.write(credentials.refresh);
    });
    if (!_current(generation)) return false;
    _credentials = credentials;
    return true;
  }

  // Serialize writes so a pending rotation cannot put a token back after wipe.
  Future<void> _write(Future<void> Function() write) {
    final operation = _storage.then((_) => write());
    _storage = operation.then<void>((_) {}, onError: (Object _) {});
    return operation;
  }

  Future<void> signOut({bool notifyServer = true}) {
    if (_signingOut case final active?) return active;
    final operation = _signOut(notifyServer);
    _signingOut = operation;
    return operation.whenComplete(() => _signingOut = null);
  }

  Future<void> _signOut(bool notifyServer) async {
    final generation = ++_generation;
    _credentials = null;
    final token = _refreshToken;
    _refreshToken = null;
    _refreshing = null;
    if (!ref.read(useApiProvider)) {
      state = const SignedOut();
      ref.invalidate(sessionProvider);
      return;
    }
    final store = ref.read(refreshStoreProvider);
    final api = ref.read(sessionApiProvider);
    var logoutToken = token;
    await _write(() async {
      if (logoutToken == null && notifyServer) {
        try {
          logoutToken = await store.read();
        } on Object {
          // Still attempt to delete the entry if the read fails.
        }
      }
      await store.write(null);
    });
    // Finish local sign-out only after the secure entry has been deleted.
    if (_current(generation)) state = const SignedOut();
    final value = logoutToken;
    if (notifyServer && value != null) {
      unawaited(
        api.logout(value).catchError((Object _) {
          // Local sign-out is already complete.
        }),
      );
    }
  }
}
