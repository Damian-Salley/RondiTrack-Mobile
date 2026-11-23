import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_mobile/app/app_config.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/session/domain/persona.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const new({this.register = false, this.from, super.key});

  final bool register;
  final String? from;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  static const _labels = {
    'firstName': 'First name',
    'lastName': 'Last name',
    'email': 'Email',
    'phoneNumber': 'Phone number',
    'password': 'Password',
  };
  final Map<String, TextEditingController> _fields = {
    for (final key in _labels.keys) key: TextEditingController(),
  };
  final _form = GlobalKey<FormState>();
  Map<String, String> _fieldErrors = {};
  String? _error;
  bool _busy = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    for (final field in _fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  void _go(String path) => context.go(
    Uri(path: path, queryParameters: {'from': ?widget.from}).toString(),
  );

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _fieldErrors = {};
    });
    if (!_form.currentState!.validate()) return;
    final auth = ref.read(authProvider.notifier);
    final email = _fields['email']!.text.trim();
    final password = _fields['password']!.text;
    setState(() => _busy = true);
    try {
      if (widget.register) {
        await auth.register({
          for (final entry in _fields.entries)
            entry.key: entry.key == 'password'
                ? password
                : entry.value.text.trim(),
        });
        if (mounted) _go('/sign-in');
      } else if (!await auth.signIn(email, password) && mounted) {
        setState(() => _error = 'Email and password do not match.');
      }
    } on ApiFailure catch (error) {
      if (!mounted) return;
      setState(() {
        switch (error) {
          case UnauthorisedFailure() when !widget.register:
            _error = 'Email and password do not match.';
          case ConflictFailure() when widget.register:
            _fieldErrors = {'email': 'Email already registered.'};
          case ValidationFailure(:final fields, :final detail)
              when widget.register:
            _fieldErrors = {
              for (final entry in fields.entries)
                if (entry.value.isNotEmpty) entry.key: entry.value.first,
            };
            if (_fieldErrors.isEmpty &&
                detail != null &&
                detail.startsWith('Password')) {
              _fieldErrors['password'] = detail;
            }
            if (_fieldErrors.isEmpty) _error = error.message;
          case RateLimitedFailure(:final waitSeconds):
            _seconds = waitSeconds ?? 60;
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(() => _seconds--);
              if (_seconds <= 0) timer.cancel();
            });
          default:
            _error = error.message;
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.register ? 'Register' : 'Sign in';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              for (final key
                  in widget.register ? _labels.keys : ['email', 'password'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _fields[key],
                    obscureText: key == 'password',
                    keyboardType: switch (key) {
                      'email' => TextInputType.emailAddress,
                      'phoneNumber' => TextInputType.phone,
                      _ => TextInputType.text,
                    },
                    decoration: InputDecoration(
                      labelText: _labels[key],
                      errorText: _fieldErrors[key],
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter your ${_labels[key]!.toLowerCase()}.'
                        : null,
                  ),
                ),
              if (_error case final message?) Text(message),
              if (_seconds > 0)
                Text('Too many requests. Try again in $_seconds seconds.'),
              FilledButton(
                onPressed: _busy || _seconds > 0 ? null : _submit,
                child: Text(title),
              ),
              TextButton(
                onPressed: _busy || _seconds > 0
                    ? null
                    : () => _go(widget.register ? '/sign-in' : '/register'),
                child: Text(
                  widget.register ? 'Back to sign in' : 'Create account',
                ),
              ),
              if (!widget.register &&
                  ref.watch(appConfigProvider).flavor == 'dev')
                PopupMenuButton<Persona>(
                  key: const Key('persona-switcher'),
                  enabled: !_busy,
                  tooltip: 'Choose dev persona',
                  onSelected: (persona) {
                    _fields['email']!.text = persona.email;
                    _fields['password']!.clear();
                  },
                  itemBuilder: (_) => [
                    for (final persona in Persona.values)
                      PopupMenuItem(value: persona, child: Text(persona.label)),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Choose dev persona'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RestoreScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: Center(
        child: auth is Restoring && auth.failed
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not reach RondiTrack to restore your session.',
                  ),
                  FilledButton(
                    onPressed: () => ref.read(authProvider.notifier).restore(),
                    child: const Text('Try again'),
                  ),
                  TextButton(
                    onPressed: () => ref.read(authProvider.notifier).signOut(),
                    child: const Text('Sign out'),
                  ),
                ],
              )
            : const CircularProgressIndicator(
                semanticsLabel: 'Restoring session',
              ),
      ),
    );
  }
}
