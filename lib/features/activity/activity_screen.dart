import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/activity/activity_provider.dart';

export 'activity_provider.dart' show activityProvider;

class ActivityScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = toViewState(
      ref.watch(activityProvider),
      isEmpty: (items) => items.isEmpty,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: switch (state) {
        Loading() => const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Loading activity'),
        ),
        Empty() => const StateMessage(message: 'No activity yet.'),
        Failure(:final message, :final apiFailure) => StateMessage(
          message: message,
          apiFailure: apiFailure,
          retry: () => ref.invalidate(activityProvider),
        ),
        Data(:final value) => ListView(
          children: [
            for (final item in value)
              ListTile(
                title: Text(item.memberName),
                subtitle: Text(
                  'Stokvel ${item.stokvelId} · ${item.status.label}\n'
                  '${formatCents(item.amount)}',
                ),
              ),
          ],
        ),
      },
    );
  }
}
