import 'package:flutter/material.dart';
import 'package:ronditrack_mobile/app/router.dart';

class JoinScreen extends StatelessWidget {
  const new({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Invite preview'),
      leading: BackButton(onPressed: () => const HomeRoute().go(context)),
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Invite code: $code'),
        const Text(
          'Preview a fake invite. Membership changes arrive in Week 11.',
        ),
        FilledButton(
          onPressed: () {
            const HomeRoute().go(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fake join complete. No membership changed.'),
              ),
            );
          },
          child: const Text('Join'),
        ),
      ],
    ),
  );
}
