// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// LoginNotifier gestiona el estado de la pantalla de login.
///
/// NO tiene keepAlive → se destruye automáticamente cuando LoginPage
/// desaparece del árbol de widgets. Eso limpia memoria y reinicia el estado.
///
/// Equivalente GetX: el LoginController que ponías en Get.put() dentro del
/// binding de la ruta /login.

@ProviderFor(LoginNotifier)
final loginProvider = LoginNotifierProvider._();

/// LoginNotifier gestiona el estado de la pantalla de login.
///
/// NO tiene keepAlive → se destruye automáticamente cuando LoginPage
/// desaparece del árbol de widgets. Eso limpia memoria y reinicia el estado.
///
/// Equivalente GetX: el LoginController que ponías en Get.put() dentro del
/// binding de la ruta /login.
final class LoginNotifierProvider
    extends $NotifierProvider<LoginNotifier, LoginState> {
  /// LoginNotifier gestiona el estado de la pantalla de login.
  ///
  /// NO tiene keepAlive → se destruye automáticamente cuando LoginPage
  /// desaparece del árbol de widgets. Eso limpia memoria y reinicia el estado.
  ///
  /// Equivalente GetX: el LoginController que ponías en Get.put() dentro del
  /// binding de la ruta /login.
  LoginNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginNotifierHash();

  @$internal
  @override
  LoginNotifier create() => LoginNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoginState>(value),
    );
  }
}

String _$loginNotifierHash() => r'd8592934df9bc753218d2728c135be8361edda14';

/// LoginNotifier gestiona el estado de la pantalla de login.
///
/// NO tiene keepAlive → se destruye automáticamente cuando LoginPage
/// desaparece del árbol de widgets. Eso limpia memoria y reinicia el estado.
///
/// Equivalente GetX: el LoginController que ponías en Get.put() dentro del
/// binding de la ruta /login.

abstract class _$LoginNotifier extends $Notifier<LoginState> {
  LoginState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LoginState, LoginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoginState, LoginState>,
              LoginState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
