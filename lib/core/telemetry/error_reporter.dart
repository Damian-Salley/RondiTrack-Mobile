import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const _apiFailureMessage = 'API request failed';
const _unexpectedMessage = 'Unexpected application error';
const correlationTag = 'correlationId';

final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const DisabledErrorReporter(),
);

abstract interface class ErrorReporter {
  Future<void> report(Object failure);
}

class DisabledErrorReporter implements ErrorReporter {
  const new();

  @override
  Future<void> report(Object failure) async {}
}

class SentryErrorReporter implements ErrorReporter {
  const new();

  @override
  Future<void> report(Object failure) async {
    if (failure is ApiFailure && failure is! ServerFailure) return;
    final correlationId = failure is ServerFailure
        ? failure.correlationId
        : null;
    await Sentry.captureEvent(
      SentryEvent(
        message: SentryMessage(
          failure is ServerFailure ? _apiFailureMessage : _unexpectedMessage,
        ),
        level: SentryLevel.error,
        tags: {correlationTag: ?correlationId},
      ),
    );
  }
}

final _traceId = RegExp(r'^(?:[a-f0-9]{32}|[A-Z0-9]{13}:[A-F0-9]{8})$');

/// Rebuild the event from a narrow allowlist. Free-form fields can contain
/// unexpected encodings of member information, including under unknown keys.
SentryEvent scrubEvent(SentryEvent event, {String? memberName}) {
  final candidate = event.tags?[correlationTag];
  final correlationId =
      candidate != null &&
          _traceId.hasMatch(candidate) &&
          (memberName == null ||
              memberName.isEmpty ||
              !candidate.toLowerCase().contains(memberName.toLowerCase()))
      ? candidate
      : null;
  return SentryEvent(
    eventId: event.eventId,
    timestamp: event.timestamp,
    environment: event.environment,
    release: event.release,
    dist: event.dist,
    sdk: event.sdk,
    platform: event.platform,
    level: event.level,
    message: SentryMessage(
      event.message?.formatted == _apiFailureMessage
          ? _apiFailureMessage
          : _unexpectedMessage,
    ),
    tags: {correlationTag: ?correlationId},
  );
}
