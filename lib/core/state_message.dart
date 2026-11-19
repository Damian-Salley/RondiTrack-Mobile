import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';

/// Displays a message for empty or failed screen states.
class StateMessage extends StatelessWidget {
  const new({required this.message, this.retry, this.apiFailure, super.key});

  final String message;
  final VoidCallback? retry;
  final ApiFailure? apiFailure;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display the message in the centre of the screen.
          Text(message, textAlign: TextAlign.center),

          if (apiFailure case ServerFailure(correlationId: final reference?))
            TextButton(
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: reference)),
              child: Text('Copy reference: $reference'),
            ),

          // Only show the retry button when a retry action is provided.
          if (retry != null &&
              (apiFailure == null || apiFailure is OfflineFailure))
            FilledButton(
              onPressed: retry,
              child: Text(apiFailure is OfflineFailure ? 'Try again' : 'Retry'),
            ),
        ],
      ),
    ),
  );
}
