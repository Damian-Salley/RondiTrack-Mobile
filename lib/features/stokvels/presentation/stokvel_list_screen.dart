import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/app/router.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/home/presentation/home_notifier.dart';

class StokvelListScreen extends ConsumerWidget {
  const new({this.selectedId, super.key});

  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = toViewState(
      ref.watch(homeProvider),
      isEmpty: (entries) => entries.isEmpty,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Stokvels')),
      body: switch (state) {
        Loading() => const Center(child: CircularProgressIndicator()),
        Empty() => const StateMessage(message: 'No stokvels yet.'),
        Failure(:final message) => StateMessage(
          message: message,
          retry: () => ref.invalidate(homeProvider),
        ),
        Data(:final value) => ListView(
          children: [
            for (final entry in value)
              ListTile(
                selected: selectedId == '${entry.membership.stokvelId}',
                title: Text(entry.stokvelName),
                subtitle: Text(entry.membership.role.label),
                onTap: () =>
                    StokvelRoute(id: '${entry.membership.stokvelId}')
                        .go(context),
              ),
          ],
        ),
      },
    );
  }
}
