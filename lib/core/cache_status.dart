import 'package:flutter/material.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:ronditrack_mobile/core/state_message.dart';
import 'package:ronditrack_mobile/l10n/localization.dart';

class CacheStatus extends StatelessWidget {
  const new({
    required this.updatedAt,
    required this.refreshing,
    required this.failure,
    required this.retry,
    this.showReference = false,
    super.key,
  });

  final DateTime? updatedAt;
  final bool refreshing;
  final ApiFailure? failure;
  final bool showReference;
  final Future<void> Function() retry;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        if (updatedAt case final time?)
          Text(strings.lastUpdated(context.formatTime(time))),
        if (failure != null && failure is! NotFoundFailure)
          Semantics(
            liveRegion: true,
            child: Text(
              failure is OfflineFailure
                  ? strings.offline
                  : strings.refreshFailed,
            ),
          ),
        if (showReference)
          if (failure case ServerFailure(correlationId: final reference?))
            FailureReference(key: ValueKey(reference), reference: reference),
        if (refreshing) ...[
          Text(strings.refreshing),
          const LinearProgressIndicator(),
        ],
        if (failure != null && !refreshing && failure is! NotFoundFailure)
          OutlinedButton(onPressed: retry, child: Text(strings.tryAgain)),
      ],
    );
  }
}
