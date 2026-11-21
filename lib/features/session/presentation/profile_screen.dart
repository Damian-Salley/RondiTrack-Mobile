import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (auth case SignedIn(:final label)) Text(label),
          FilledButton(
            onPressed: () async {
              final wipe = ref.read(authProvider.notifier).signOut();
              context.go('/sign-in');
              await wipe;
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
