// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokvel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the repository used to retrieve stokvel details.

@ProviderFor(stokvelRepository)
final stokvelRepositoryProvider = StokvelRepositoryProvider._();

/// Provides the repository used to retrieve stokvel details.

final class StokvelRepositoryProvider
    extends
        $FunctionalProvider<
          StokvelRepository,
          StokvelRepository,
          StokvelRepository
        >
    with $Provider<StokvelRepository> {
  /// Provides the repository used to retrieve stokvel details.
  StokvelRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokvelRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokvelRepositoryHash();

  @$internal
  @override
  $ProviderElement<StokvelRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StokvelRepository create(Ref ref) {
    return stokvelRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StokvelRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StokvelRepository>(value),
    );
  }
}

String _$stokvelRepositoryHash() => r'b2fcf87c12318fd9d2167440afe1760b3d5691be';

@ProviderFor(cycleDetail)
final cycleDetailProvider = CycleDetailFamily._();

final class CycleDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<StokvelDetail?>,
          StokvelDetail?,
          FutureOr<StokvelDetail?>
        >
    with $FutureModifier<StokvelDetail?>, $FutureProvider<StokvelDetail?> {
  CycleDetailProvider._({
    required CycleDetailFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'cycleDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cycleDetailHash();

  @override
  String toString() {
    return r'cycleDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<StokvelDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StokvelDetail?> create(Ref ref) {
    final argument = this.argument as (int, int);
    return cycleDetail(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CycleDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cycleDetailHash() => r'20b5bb2101696f07b1668119fffa91614817bc4d';

final class CycleDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StokvelDetail?>, (int, int)> {
  CycleDetailFamily._()
    : super(
        retry: null,
        name: r'cycleDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CycleDetailProvider call(int stokvelId, int cycleId) =>
      CycleDetailProvider._(argument: (stokvelId, cycleId), from: this);

  @override
  String toString() => r'cycleDetailProvider';
}

@ProviderFor(cycleClosePreview)
final cycleClosePreviewProvider = CycleClosePreviewFamily._();

final class CycleClosePreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<CycleClosePreview>,
          CycleClosePreview,
          FutureOr<CycleClosePreview>
        >
    with
        $FutureModifier<CycleClosePreview>,
        $FutureProvider<CycleClosePreview> {
  CycleClosePreviewProvider._({
    required CycleClosePreviewFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'cycleClosePreviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cycleClosePreviewHash();

  @override
  String toString() {
    return r'cycleClosePreviewProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<CycleClosePreview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CycleClosePreview> create(Ref ref) {
    final argument = this.argument as (int, int);
    return cycleClosePreview(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CycleClosePreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cycleClosePreviewHash() => r'6e0128c59821668e557b6092f9e5ab59d634dcfb';

final class CycleClosePreviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CycleClosePreview>, (int, int)> {
  CycleClosePreviewFamily._()
    : super(
        retry: null,
        name: r'cycleClosePreviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CycleClosePreviewProvider call(int stokvelId, int cycleId) =>
      CycleClosePreviewProvider._(argument: (stokvelId, cycleId), from: this);

  @override
  String toString() => r'cycleClosePreviewProvider';
}
