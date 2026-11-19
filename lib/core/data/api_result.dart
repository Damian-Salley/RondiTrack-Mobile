import 'package:ronditrack_mobile/core/data/map_api_failure.dart';
import 'package:ronditrack_mobile/core/result.dart';

Future<Result<T>> apiResult<T>(Future<T> Function() request) async {
  try {
    return (value: await request(), failure: null);
  } on Object catch (error) {
    return (value: null, failure: mapApiFailure(error));
  }
}

/// The existing repository interfaces signal errors to Riverpod by throwing.
extension UnwrapResult<T> on Result<T> {
  T unwrap() {
    if (failure case final error?) throw error;
    return value as T;
  }
}

/// OpenAPI integer schemas allow numbers encoded as strings by ASP.NET.
int apiInteger(Object? value) => switch (value) {
  final int number => number,
  final String number => int.parse(number),
  _ => throw const FormatException('Expected an integer'),
};
