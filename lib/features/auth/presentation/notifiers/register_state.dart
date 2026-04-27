import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user_entity.dart';

part 'register_state.freezed.dart';

/// Estado de la pantalla de registro.
///
/// Sealed class — el compilador obliga a manejar todos los casos en la View.
@freezed
sealed class RegisterState with _$RegisterState {
  /// Estado inicial — formulario vacío, sin actividad.
  const factory RegisterState.initial() = RegisterStateInitial;

  /// Enviando el formulario al servidor (S04).
  const factory RegisterState.loading() = RegisterStateLoading;

  /// Registro enviado exitosamente.
  /// El usuario queda en estado "pendiente de aprobación".
  /// La View navega a PendingApprovalPage.
  const factory RegisterState.success(UserEntity user) = RegisterStateSuccess;

  /// Algo salió mal. [message] para mostrar al usuario.
  /// [field] indica qué campo falló (para resaltar el campo en el form).
  const factory RegisterState.error({
    required String message,
    String? field,
  }) = RegisterStateError;
}
