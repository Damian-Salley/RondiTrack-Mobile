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
            _FailureReference(key: ValueKey(reference), reference: reference),

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

/// Retain the displayed reference until the person dismisses it.
class _FailureReference extends StatefulWidget {
  const new({required this.reference, super.key});

  final String reference;

  @override
  State<_FailureReference> createState() => _FailureReferenceState();
}

class _FailureReferenceState extends State<_FailureReference> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        TextButton(
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: widget.reference)),
          child: Text('Copy reference: ${widget.reference}'),
        ),
        TextButton(
          onPressed: () => setState(() => _dismissed = true),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
