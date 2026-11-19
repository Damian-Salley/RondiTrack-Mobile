import 'package:ronditrack_mobile/core/api_failure.dart';

/// Data calls return either a domain value or a user-facing failure.
typedef Result<T> = ({T? value, ApiFailure? failure});
