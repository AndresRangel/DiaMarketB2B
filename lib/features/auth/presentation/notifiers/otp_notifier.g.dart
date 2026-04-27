// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// OtpNotifier gestiona el estado de la pantalla OTP.
///
/// Sin keepAlive → se destruye cuando OtpPage desaparece del árbol.
/// Esto reinicia el estado (y el countdown) si el usuario vuelve atrás.

@ProviderFor(OtpNotifier)
final otpProvider = OtpNotifierProvider._();

/// OtpNotifier gestiona el estado de la pantalla OTP.
///
/// Sin keepAlive → se destruye cuando OtpPage desaparece del árbol.
/// Esto reinicia el estado (y el countdown) si el usuario vuelve atrás.
final class OtpNotifierProvider
    extends $NotifierProvider<OtpNotifier, OtpState> {
  /// OtpNotifier gestiona el estado de la pantalla OTP.
  ///
  /// Sin keepAlive → se destruye cuando OtpPage desaparece del árbol.
  /// Esto reinicia el estado (y el countdown) si el usuario vuelve atrás.
  OtpNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpNotifierHash();

  @$internal
  @override
  OtpNotifier create() => OtpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OtpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OtpState>(value),
    );
  }
}

String _$otpNotifierHash() => r'ca562e6254df4353a030524e6e631b30c6ebab69';

/// OtpNotifier gestiona el estado de la pantalla OTP.
///
/// Sin keepAlive → se destruye cuando OtpPage desaparece del árbol.
/// Esto reinicia el estado (y el countdown) si el usuario vuelve atrás.

abstract class _$OtpNotifier extends $Notifier<OtpState> {
  OtpState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OtpState, OtpState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OtpState, OtpState>,
              OtpState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
