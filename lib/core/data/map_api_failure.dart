import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ronditrack_mobile/core/api_failure.dart';

/// Reads ProblemDetails extensions from the raw response.
String? responseCorrelationId(Object? body) {
  final id = body is Map<String, dynamic> ? body['correlationId'] : null;
  return id is String && id.isNotEmpty ? id : null;
}

/// Converts transport, decoding and concurrent errors at the data boundary.
ApiFailure mapApiFailure(Object error) {
  if (error is ApiFailure) return error;
  if (error is ParallelWaitError<Object?, Object?>) {
    final errors = switch (error.errors) {
      (final AsyncError? first, final AsyncError? second) => [first, second],
      (
        final AsyncError? first,
        final AsyncError? second,
        final AsyncError? third,
      ) =>
        [first, second, third],
      final Iterable<AsyncError?> values => values,
      _ => const <AsyncError?>[],
    };
    final failures = errors.nonNulls.map((item) => mapApiFailure(item.error));
    // An inaccessible resource should show the same result as a missing one.
    return failures.whereType<NotFoundFailure>().firstOrNull ??
        failures.firstOrNull ??
        const ServerFailure(null);
  }
  if (error is! DioException) return const ServerFailure(null);
  if (error.error case final ApiFailure failure) return failure;

  final response = error.response;
  if (response == null) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => const OfflineFailure(),
      _ => const ServerFailure(null),
    };
  }

  final body = response.data;
  final problem = body is Map<String, dynamic> ? body : null;
  final detail = problem?['detail'];
  final text = detail is String ? detail : null;
  final status = response.statusCode ?? 0;
  return switch (status) {
    400 => ValidationFailure(
      text ?? (body is String ? body : null),
      _fieldErrors(problem?['errors']),
    ),
    401 => const UnauthorisedFailure(),
    403 => const ForbiddenFailure(),
    404 => const NotFoundFailure(),
    409 || 412 => ConflictFailure(text),
    429 => RateLimitedFailure(
      int.tryParse(response.headers.value('retry-after') ?? ''),
    ),
    >= 400 && < 500 => RuleFailure(text),
    _ => ServerFailure(responseCorrelationId(body)),
  };
}

Map<String, List<String>> _fieldErrors(Object? errors) {
  if (errors is! Map<String, dynamic>) return const {};
  return {
    for (final entry in errors.entries)
      if (entry.value case final List<dynamic> values)
        entry.key: values.whereType<String>().toList(growable: false),
  };
}
