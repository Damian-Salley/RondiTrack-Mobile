import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/app/repository_mode.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
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
        Text(
          ref.watch(useApiProvider)
              ? 'Enter a development seed email.'
              : 'Fake sign-in: enter a seed email.',
        ),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Email', errorText: _error),
        ),
        FilledButton(
          onPressed: () async {
            // The auth listener re-runs the gate and restores the destination.
            try {
              final signedIn = await ref
                  .read(authProvider.notifier)
                  .signIn(_email.text);
              if (mounted && !signedIn) {
                setState(() => _error = 'Enter a valid seed email.');
              }
            } on ApiFailure catch (error) {
              if (mounted) setState(() => _error = error.message);
            }
          },
          child: const Text('Sign in'),
        ),
        if (ref.watch(appConfigProvider).flavor == 'dev')
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
