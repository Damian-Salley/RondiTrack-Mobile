import 'package:flutter/material.dart';

/// Displays a message for empty or failed screen states.
class StateMessage extends StatelessWidget {
  const new({required this.message, this.retry, super.key});

  final String message;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display the message in the centre of the screen.
          Text(message, textAlign: TextAlign.center),

          // Only show the retry button when a retry action is provided.
          if (retry != null)
            FilledButton(onPressed: retry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
