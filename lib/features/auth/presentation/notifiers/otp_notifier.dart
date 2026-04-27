// Este archivo es Dart puro + Riverpod. Sin imports de Flutter.
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import 'auth_notifier.dart';
import 'otp_state.dart';

part 'otp_notifier.g.dart';

/// OtpNotifier gestiona el estado de la pantalla OTP.
///
/// Sin keepAlive → se destruye cuando OtpPage desaparece del árbol.
/// Esto reinicia el estado (y el countdown) si el usuario vuelve atrás.
@riverpod
class OtpNotifier extends _$OtpNotifier {
  // Timer para el countdown de "Reenviar código".
  // Es un detalle de lógica (no de UI), por eso vive en el Notifier.
  Timer? _resendTimer;

  @override
  OtpState build() {
    // ref.onDispose se ejecuta cuando el Notifier se destruye
    // (cuando OtpPage desaparece del árbol de widgets).
    // Es la forma correcta en Riverpod de limpiar recursos como timers.
    ref.onDispose(() => _resendTimer?.cancel());
    return const OtpState.initial();
  }

  // ── Acción 1: Enviar OTP ──────────────────────────────────────────────────

  /// Solicita al servidor que envíe un SMS con el código OTP al [phone].
  /// La View llama esto cuando el usuario toca "Enviar código" o "Reenviar".
  Future<void> sendOtp(String phone) async {
    if (phone.trim().isEmpty) {
      state = const OtpState.error(message: 'Ingresa tu número de celular');
      return;
    }

    state = const OtpState.sendingOtp();

    final useCase = ref.read(sendOtpUseCaseProvider);
    final result = await useCase(phone.trim());

    result.fold(
      (failure) => state = OtpState.error(
        message: _failureMessage(failure),
        previousPhone: phone.trim(),
      ),
      (_) {
        // Éxito: el SMS fue enviado. Iniciamos el countdown de 60s.
        state = OtpState.otpSent(phone: phone.trim());
        _startResendTimer(phone.trim());
      },
    );
  }

  // ── Acción 2: Validar código ──────────────────────────────────────────────

  /// Valida el código OTP de 6 dígitos ingresado por el usuario.
  /// La View llama esto cuando el usuario completa los 6 dígitos y toca "Verificar".
  Future<void> validateOtp({
    required String phone,
    required String code,
    required OtpFlow flow,
  }) async {
    if (code.length != 6) {
      state = OtpState.error(
        message: 'El código debe tener 6 dígitos',
        previousPhone: phone,
      );
      return;
    }

    state = const OtpState.validating();

    final useCase = ref.read(validateOtpUseCaseProvider);
    final result = await useCase(phone: phone, code: code);

    result.fold(
      (failure) => state = OtpState.error(
        message: _failureMessage(failure),
        previousPhone: phone,
      ),
      (isValid) {
        if (isValid) {
          // OTP correcto → éxito. La View navegará según el flujo.
          _resendTimer?.cancel();
          state = const OtpState.success();
        } else {
          // El servidor respondió OK pero el código no era válido.
          state = OtpState.error(
            message: 'Código incorrecto. Verifica e intenta de nuevo.',
            previousPhone: phone,
          );
        }
      },
    );
  }

  // ── Acción 3: Volver a pedir teléfono ────────────────────────────────────

  /// Regresa al estado inicial para que el usuario corrija su número.
  void resetToInitial() {
    _resendTimer?.cancel();
    state = const OtpState.initial();
  }

  // ── Lógica del countdown ──────────────────────────────────────────────────

  /// Inicia el timer de 60 segundos. Cada segundo decrementa [resendCooldown].
  /// Cuando llega a 0, el botón "Reenviar" se habilita.
  void _startResendTimer(String phone) {
    _resendTimer?.cancel();

    // Timer.periodic dispara el callback cada [duration].
    // Es el equivalente a setInterval en JavaScript.
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state;
      if (current is! OtpStateOtpSent) {
        timer.cancel();
        return;
      }

      final remaining = current.resendCooldown - 1;

      if (remaining <= 0) {
        timer.cancel();
        // Cooldown terminó → actualizamos a 0 para que la View habilite "Reenviar"
        state = current.copyWith(resendCooldown: 0);
      } else {
        state = current.copyWith(resendCooldown: remaining);
      }
    });
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  String _failureMessage(Failure failure) => failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        network: (_) => 'Sin conexión. Verifica tu internet.',
        validation: (msg, _) => msg,
        unauthorized: (_) => 'Sesión inválida. Intenta de nuevo.',
        unknown: (msg) => msg,
      );
}
