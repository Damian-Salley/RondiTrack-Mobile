import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

final FutureProviderFamily<int, String> _joinProvider = FutureProvider
    .autoDispose
    .family<int, String>((ref, code) {
      if (ref.watch(authProvider) is! SignedIn) {
        throw const UnauthorisedFailure();
      }
      final joins = ref.watch(joinAttemptsProvider);
      final join = ref.watch(joinInviteProvider);
      return joins.putIfAbsent(code, () => join(code));
    }, retry: (_, _) => null);

class JoinScreen extends ConsumerWidget {
  const new({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(_joinProvider(code));
    if (result case AsyncData(:final value)) {
      final session = ref.read(authProvider);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted &&
            identical(ref.read(authProvider), session) &&
            ModalRoute.of(context)?.isCurrent == true) {
          StokvelRoute(id: '$value').go(context);
        }
      });
    }
    final error = result.error;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join stokvel'),
        leading: BackButton(onPressed: () => const HomeRoute().go(context)),
      ),
      body: Center(
        child: error == null
            ? const CircularProgressIndicator(semanticsLabel: 'Joining stokvel')
            : Text(switch (error) {
                NotFoundFailure() =>
                  'Invite code not found. Check the code and try again.',
                ApiFailure() => error.message,
                _ => 'Could not join this stokvel.',
              }),
      ),
    );
  }
}
