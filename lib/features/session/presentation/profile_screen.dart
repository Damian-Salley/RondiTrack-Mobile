import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ronditrack_mobile/core/offline_mode.dart';
import 'package:ronditrack_mobile/features/contributions/contribution_providers.dart';
import 'package:ronditrack_mobile/features/session/presentation/auth_provider.dart';
import 'package:ronditrack_mobile/l10n/language_preference.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

class ProfileScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final strings = context.strings;
    final language = ref.watch(languageProvider).value?.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(strings.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (auth case SignedIn(:final label)) Text(label),
          DropdownButtonFormField<String>(
            initialValue: language ?? '',
            decoration: InputDecoration(labelText: strings.language),
            isExpanded: true,
            items: [
              DropdownMenuItem(value: '', child: Text(strings.systemLanguage)),
              DropdownMenuItem(value: 'en', child: Text(strings.english)),
              DropdownMenuItem(value: 'af', child: Text(strings.afrikaans)),
            ],
            onChanged: (code) => ref
                .read(languageProvider.notifier)
                .choose(code == '' ? null : code),
          ),
          FilledButton(
            onPressed: () async {
              final router = GoRouter.of(context);
              if (ref.read(offlineStorageEnabledProvider)) {
                final pending = await ref
                    .read(paymentOutboxStoreProvider)
                    .read();
                if (!context.mounted) return;
                if (pending.isNotEmpty) {
                  final discard = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(strings.discardPayments),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(strings.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(strings.discardAndSignOut),
                        ),
                      ],
                    ),
                  );
                  if (discard != true || !context.mounted) return;
                }
              }
              await ref.read(authProvider.notifier).signOut();
              router.go('/sign-in');
            },
            child: Text(strings.signOut),
          ),
        ],
      ),
    );
  }
}
