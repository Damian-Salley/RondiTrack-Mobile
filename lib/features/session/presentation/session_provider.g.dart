// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Session)
final sessionProvider = SessionProvider._();

final class SessionProvider extends $NotifierProvider<Session, Persona> {
  SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Persona value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Persona>(value),
    );
  }
}

String _$sessionHash() => r'3ac4c119ff2c3df19723371ae0e7612d36b62640';

abstract class _$Session extends $Notifier<Persona> {
  Persona build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Persona, Persona>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Persona, Persona>,
              Persona,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
