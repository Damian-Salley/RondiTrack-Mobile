import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the different states a screen can display.
sealed class ViewState<T> {
  const new();
}

/// Data is currently being loaded.
final class Loading<T> extends ViewState<T> {
  const new();
}

/// Loading succeeded, but no data was found.
final class Empty<T> extends ViewState<T> {
  const new();
}

/// Loading succeeded and data is available.
final class Data<T> extends ViewState<T> {
  const new(this.value, {this.refreshing = false});

  final T value;
  final bool refreshing;
}

/// Loading failed and an error message is available.
final class Failure<T> extends ViewState<T> {
  const new(this.message);

  final String message;
}

/// Converts Riverpod's asynchronous state into a screen-friendly state.
ViewState<T> toViewState<T>(
  AsyncValue<T> state, {
  required bool Function(T) isEmpty,
}) {
  // Discard previous data when dependencies change, such as switching users.
  if (state.isReloading) return const Loading();

  // Display an error when loading fails.
  if (state.hasError && !state.isLoading) {
    return const Failure('Could not load your data. Please try again.');
  }

  // Display available data, including existing data during a refresh.
  if (state.hasValue) {
    final value = state.requireValue;

    if (isEmpty(value)) return const Empty();

    return Data(value, refreshing: state.isLoading);
  }

  // Show loading when no data is available yet.
  return const Loading();
}
