import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sign in')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Fake sign-in: enter a seed email or choose one below.'),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Email', errorText: _error),
        ),
        FilledButton(
          onPressed: () {
            // The auth listener re-runs the gate and restores the destination.
            if (!ref.read(authProvider.notifier).signIn(_email.text)) {
              setState(() => _error = 'Choose one of the seed emails below.');
            }
          },
          child: const Text('Sign in'),
        ),
        for (final persona in Persona.values)
          ListTile(
            title: Text(persona.label),
            subtitle: Text(persona.email),
            onTap: () => _email.text = persona.email,
          ),
      ],
    ),
  );
}
