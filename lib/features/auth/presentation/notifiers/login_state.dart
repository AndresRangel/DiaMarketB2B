import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/company_entity.dart';

part 'login_state.freezed.dart';

/// Estado de la pantalla de login.
///
/// Es una sealed class: el compilador Dart obliga a manejar TODOS los casos
/// en cada switch. Si agregas un nuevo estado aquí, el compilador te avisa
/// en la View que falta manejarlo.
///
/// Equivalente GetX: las variables sueltas como `isLoading.obs`, `error.obs`,
/// `companies.obs` que ponías en el LoginController. Aquí todo es un solo objeto.
@freezed
sealed class LoginState with _$LoginState {
  /// Estado inicial — el usuario aún no ha intentado hacer login.
  const factory LoginState.initial() = LoginStateInitial;

  /// Login en proceso — esperando respuesta del servidor.
  /// La View muestra un spinner y deshabilita el botón.
  const factory LoginState.loading() = LoginStateLoading;

  /// Login exitoso con una sola empresa — ya está listo para ir al home.
  /// El Notifier ya llamó a AuthNotifier.onLoginSuccess().
  const factory LoginState.success(AuthSessionEntity session) = LoginStateSuccess;

  /// Login exitoso pero el usuario tiene MÚLTIPLES empresas.
  /// La View debe mostrar un diálogo/pantalla para que el usuario elija una.
  /// Una vez que el usuario elija, se llama a LoginNotifier.selectCompany().
  const factory LoginState.needsCompanySelection({
    required AuthSessionEntity session,
    required List<CompanyEntity> companies,
  }) = LoginStateNeedsCompanySelection;

  /// Algo salió mal. [message] es el texto para mostrar al usuario.
  const factory LoginState.error(String message) = LoginStateError;
}
