import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_state.freezed.dart';

/// Define desde dónde se abrió la pantalla OTP.
/// Cambia qué pasa después de validar exitosamente el código.
enum OtpFlow {
  /// Flujo "olvidé mi contraseña" → después del OTP, ir a cambiar contraseña
  /// (por ahora navega a Login con un mensaje de éxito)
  recoverPassword,

  /// Flujo verificación de registro → después del OTP, el usuario puede ingresar
  registration,
}

/// Estado de la pantalla OTP.
///
/// Sealed class: el compilador obliga a manejar todos los casos en la View.
/// Cubre dos sub-flujos:
///   1. Enviar OTP al teléfono (sendingOtp → otpSent)
///   2. Validar el código ingresado (validating → success / error)
@freezed
sealed class OtpState with _$OtpState {
  /// Estado inicial — pantalla recién abierta, esperando que el usuario
  /// ingrese su teléfono (si no llegó como parámetro de ruta).
  const factory OtpState.initial() = OtpStateInitial;

  /// Enviando el OTP al teléfono — esperando respuesta del servidor (S02).
  const factory OtpState.sendingOtp() = OtpStateSendingOtp;

  /// OTP enviado exitosamente. Ahora el usuario debe ingresar el código.
  /// [phone] se guarda para mostrarlo en pantalla ("Enviamos el código a 300...")
  /// [resendCooldown] segundos restantes hasta poder reenviar (inicia en 60).
  const factory OtpState.otpSent({
    required String phone,
    @Default(60) int resendCooldown,
  }) = OtpStateOtpSent;

  /// Validando el código ingresado — esperando respuesta del servidor.
  const factory OtpState.validating() = OtpStateValidating;

  /// Código validado correctamente. La View navega según el flujo.
  const factory OtpState.success() = OtpStateSuccess;

  /// Algo salió mal. [message] es el texto para mostrar al usuario.
  /// [previousPhone] permite volver al estado otpSent para reintentar.
  const factory OtpState.error({
    required String message,
    String? previousPhone,
  }) = OtpStateError;
}
