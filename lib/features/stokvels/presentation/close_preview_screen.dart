import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/money.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/core/view_state.dart';
import 'package:ronditrack_mobile/features/stokvels/stokvel_providers.dart';

class ClosePreviewScreen extends ConsumerWidget {
  const new({required this.stokvelId, required this.cycleId, super.key});

  final int stokvelId;
  final int cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = cycleClosePreviewProvider(stokvelId, cycleId);
    final state = toViewState(ref.watch(provider), isEmpty: (_) => false);
    return Scaffold(
      appBar: AppBar(title: const Text('Close preview')),
      body: switch (state) {
        Loading() => const Center(child: CircularProgressIndicator()),
        Empty() => const StateMessage(message: 'No preview available.'),
        Failure(:final message, :final apiFailure) => StateMessage(
          message: message,
          apiFailure: apiFailure,
          retry: () => ref.invalidate(provider),
        ),
        Data(:final value) => StateMessage(
          message: 'As of ${value.date}\nTotal: ${formatCents(value.total)}',
        ),
      },
    );
  }
}
