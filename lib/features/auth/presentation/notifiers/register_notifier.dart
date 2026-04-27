// Dart puro + Riverpod. Sin imports de Flutter.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import 'auth_notifier.dart';
import 'register_state.dart';

part 'register_notifier.g.dart';

/// RegisterNotifier gestiona el estado del formulario de registro.
///
/// Sin keepAlive → se destruye cuando RegisterPage desaparece.
/// Esto reinicia el formulario si el usuario vuelve atrás.
@riverpod
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() => const RegisterState.initial();

  // ── Acción principal ──────────────────────────────────────────────────────

  /// Envía el formulario de registro al servidor (S04).
  /// La View llama este método cuando el usuario toca "Registrarme".
  Future<void> register({
    required String username,
    required String password,
    required String confirmPassword,
    required String phone,
    required String email,
    required String businessType,
    required String cityId,
    String? referralCode,
  }) async {
    // Validaciones en el ViewModel — la View no valida nada.
    if (username.trim().isEmpty) {
      state = const RegisterState.error(
        message: 'El usuario es requerido',
        field: 'username',
      );
      return;
    }
    if (password.length < 4) {
      state = const RegisterState.error(
        message: 'La contraseña debe tener al menos 4 caracteres',
        field: 'password',
      );
      return;
    }
    if (password != confirmPassword) {
      state = const RegisterState.error(
        message: 'Las contraseñas no coinciden',
        field: 'confirmPassword',
      );
      return;
    }
    if (phone.trim().isEmpty) {
      state = const RegisterState.error(
        message: 'El teléfono es requerido',
        field: 'phone',
      );
      return;
    }
    if (email.trim().isEmpty) {
      state = const RegisterState.error(
        message: 'El correo es requerido',
        field: 'email',
      );
      return;
    }
    if (businessType.isEmpty) {
      state = const RegisterState.error(
        message: 'Selecciona el tipo de negocio',
        field: 'businessType',
      );
      return;
    }

    state = const RegisterState.loading();

    final useCase = ref.read(registerUseCaseProvider);
    final result = await useCase(
      username: username.trim(),
      password: password,
      phone: phone.trim(),
      email: email.trim(),
      businessType: businessType,
      cityId: cityId,
      referralCode: referralCode?.trim(),
    );

    state = result.fold(
      (failure) => RegisterState.error(
        message: _failureMessage(failure),
        field: _failureField(failure),
      ),
      // Registro exitoso → la View navega a PendingApprovalPage
      (user) => RegisterState.success(user),
    );
  }

  // ── Utilidades ────────────────────────────────────────────────────────────

  /// Limpia el error actual y vuelve al estado inicial.
  void clearError() {
    if (state is RegisterStateError) {
      state = const RegisterState.initial();
    }
  }

  String _failureMessage(Failure failure) => failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        network: (_) => 'Sin conexión. Verifica tu internet.',
        validation: (msg, _) => msg,
        unauthorized: (_) => 'No autorizado.',
        unknown: (msg) => msg,
      );

  // Extrae el campo afectado si el servidor lo informa como ValidationFailure
  String? _failureField(Failure failure) => switch (failure) {
        ValidationFailure(:final field) => field,
        _ => null,
      };
}
