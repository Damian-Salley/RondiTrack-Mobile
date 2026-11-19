/// A user-facing failure that can cross the data layer boundary.
sealed class ApiFailure implements Exception {
  const new();

  String get message;
}

final class ValidationFailure extends ApiFailure {
  const new(this.detail, this.fields);

  final String? detail;
  final Map<String, List<String>> fields;

  @override
  String get message => detail ?? 'Check the highlighted information.';
}

final class UnauthorisedFailure extends ApiFailure {
  const new();

  @override
  String get message => 'Sign in to continue.';
}

final class ForbiddenFailure extends ApiFailure {
  const new();

  @override
  String get message => 'Your role does not allow this action.';
}

final class NotFoundFailure extends ApiFailure {
  const new();

  @override
  String get message => 'Not found';
}

final class ConflictFailure extends ApiFailure {
  const new(this.detail);

  final String? detail;

  @override
  String get message =>
      detail ?? 'This changed elsewhere. Reload and try again.';
}

final class RuleFailure extends ApiFailure {
  const new(this.detail);

  final String? detail;

  @override
  String get message => detail ?? 'This action is unavailable.';
}

final class RateLimitedFailure extends ApiFailure {
  const new(this.waitSeconds);

  final int? waitSeconds;

  @override
  String get message => switch (waitSeconds) {
    final int seconds => 'Too many requests. Try again in $seconds seconds.',
    null => 'Too many requests. Try again later.',
  };
}

final class ServerFailure extends ApiFailure {
  const new(this.correlationId);

  final String? correlationId;

  @override
  String get message => 'Sorry, something went wrong.';
}

final class OfflineFailure extends ApiFailure {
  const new();

  @override
  String get message => 'You’re offline, or we couldn’t reach the server';
}
