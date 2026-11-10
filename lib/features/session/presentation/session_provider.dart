import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';

part 'session_provider.g.dart';

// Keep the selected persona available throughout the application.
@Riverpod(keepAlive: true)
class Session extends _$Session {
  // Select the demo persona when the application starts.
  @override
  Persona build() => Persona.demo;

  // Update the selected persona only when it changes.
  void select(Persona persona) {
    if (state != persona) state = persona;
  }
}
