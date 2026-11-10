// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages asynchronous Home screen data using Riverpod.

@ProviderFor(Home)
final homeProvider = HomeProvider._();

/// Manages asynchronous Home screen data using Riverpod.
final class HomeProvider extends $AsyncNotifierProvider<Home, List<HomeEntry>> {
  /// Manages asynchronous Home screen data using Riverpod.
  HomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeHash();

  @$internal
  @override
  Home create() => Home();
}

String _$homeHash() => r'80cc59c2b37537f31d03c68ff4154dbec70093dc';

/// Manages asynchronous Home screen data using Riverpod.

abstract class _$Home extends $AsyncNotifier<List<HomeEntry>> {
  FutureOr<List<HomeEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<HomeEntry>>, List<HomeEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HomeEntry>>, List<HomeEntry>>,
              AsyncValue<List<HomeEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
