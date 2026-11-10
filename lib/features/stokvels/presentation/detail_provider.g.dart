// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches details for a specific stokvel using its ID.

@ProviderFor(detail)
final detailProvider = DetailFamily._();

/// Fetches details for a specific stokvel using its ID.

final class DetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<StokvelDetail?>,
          StokvelDetail?,
          FutureOr<StokvelDetail?>
        >
    with $FutureModifier<StokvelDetail?>, $FutureProvider<StokvelDetail?> {
  /// Fetches details for a specific stokvel using its ID.
  DetailProvider._({
    required DetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'detailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$detailHash();

  @override
  String toString() {
    return r'detailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StokvelDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StokvelDetail?> create(Ref ref) {
    final argument = this.argument as int;
    return detail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$detailHash() => r'26b739cc52b794488279b1cc0a483623e9aa2224';

/// Fetches details for a specific stokvel using its ID.

final class DetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<StokvelDetail?>, int> {
  DetailFamily._()
    : super(
        retry: null,
        name: r'detailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches details for a specific stokvel using its ID.

  DetailProvider call(int stokvelId) =>
      DetailProvider._(argument: stokvelId, from: this);

  @override
  String toString() => r'detailProvider';
}
