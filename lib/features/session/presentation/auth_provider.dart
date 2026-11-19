import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/session/data/session_api.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

final authProvider = NotifierProvider<Auth, Persona?>(Auth.new);
final seedPasswordProvider = Provider<String>(
  (ref) => const String.fromEnvironment('SEED_PASSWORD'),
);

class Auth extends Notifier<Persona?> {
  int _attempt = 0;

  @override
  Persona? build() => null;

  FutureOr<bool> signIn(String email) {
    final persona = Persona.values
        .where((person) => person.email == email.trim().toLowerCase())
        .firstOrNull;
    if (persona == null) return false;
    if (ref.read(useApiProvider)) return _signInToApi(persona);
    ref.read(sessionProvider.notifier).select(persona);
    state = persona;
    return true;
  }

  Future<bool> _signInToApi(Persona persona) async {
    final password = ref.read(seedPasswordProvider);
    if (ref.read(appConfigProvider).flavor != 'dev' || password.isEmpty) {
      throw const RuleFailure('Development sign-in requires SEED_PASSWORD.');
    }
    final attempt = ++_attempt;
    final result = await ref.read(seedSignInProvider)(persona.email, password);
    // A late login response must never replace a newer session.
    if (!ref.mounted || attempt != _attempt) return false;
    if (result.failure case final error?) throw error;
    ref.read(updateTokenProvider)(result.value);
    ref.read(sessionProvider.notifier).select(persona);
    state = persona;
    return true;
  }

  void signOut() {
    _attempt++;
    if (ref.read(useApiProvider)) ref.read(updateTokenProvider)(null);
    state = null;
    // Rebuild all persona-dependent repositories, even for the same next login.
    ref.invalidate(sessionProvider);
  }
}
