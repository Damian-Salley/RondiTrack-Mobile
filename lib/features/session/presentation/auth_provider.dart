import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/session_provider.dart';

final authProvider = NotifierProvider<Auth, Persona?>(Auth.new);

/// Fake authentication is separate from the selected 10.1 demo data.
class Auth extends Notifier<Persona?> {
  @override
  Persona? build() => null;

  bool signIn(String email) {
    final persona = Persona.values
        .where((person) => person.email == email.trim().toLowerCase())
        .firstOrNull;
    if (persona == null) return false;
    ref.read(sessionProvider.notifier).select(persona);
    state = persona;
    return true;
  }

  void signOut() {
    state = null;
    // Rebuild all persona-dependent repositories, even for the same next login.
    ref.invalidate(sessionProvider);
  }
}
