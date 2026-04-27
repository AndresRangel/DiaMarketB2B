// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// RegisterNotifier gestiona el estado del formulario de registro.
///
/// Sin keepAlive → se destruye cuando RegisterPage desaparece.
/// Esto reinicia el formulario si el usuario vuelve atrás.

@ProviderFor(RegisterNotifier)
final registerProvider = RegisterNotifierProvider._();

/// RegisterNotifier gestiona el estado del formulario de registro.
///
/// Sin keepAlive → se destruye cuando RegisterPage desaparece.
/// Esto reinicia el formulario si el usuario vuelve atrás.
final class RegisterNotifierProvider
    extends $NotifierProvider<RegisterNotifier, RegisterState> {
  /// RegisterNotifier gestiona el estado del formulario de registro.
  ///
  /// Sin keepAlive → se destruye cuando RegisterPage desaparece.
  /// Esto reinicia el formulario si el usuario vuelve atrás.
  RegisterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerNotifierHash();

  @$internal
  @override
  RegisterNotifier create() => RegisterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterState>(value),
    );
  }
}

String _$registerNotifierHash() => r'2e10e8176fc44b88fab114eeba37704c7aca2569';

/// RegisterNotifier gestiona el estado del formulario de registro.
///
/// Sin keepAlive → se destruye cuando RegisterPage desaparece.
/// Esto reinicia el formulario si el usuario vuelve atrás.

abstract class _$RegisterNotifier extends $Notifier<RegisterState> {
  RegisterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RegisterState, RegisterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RegisterState, RegisterState>,
              RegisterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
