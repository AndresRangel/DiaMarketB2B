import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_session_entity.dart';

part 'auth_state.freezed.dart';

/// Estado global de autenticación de la app.
///
/// Es una sealed class: el compilador obliga a manejar TODOS los casos
/// en cada switch. Si mañana se agrega un nuevo estado, el compilador
/// avisará en todos los lugares donde se usa.
///
/// Equivalente GetX: el RxBool `isLoggedIn.obs` y el RxnObject `currentUser.obs`
/// que vivían en el AuthController. Aquí todo el estado está en un solo objeto.
@freezed
sealed class AuthState with _$AuthState {
  /// Estado inicial — la app acaba de abrir y aún no sabe si hay sesión.
  /// SplashPage llama a AuthNotifier.initialize() para resolver esto.
  const factory AuthState.initial() = AuthStateInitial;

  /// Hay una sesión activa y válida. El usuario puede usar la app.
  /// Incluye todos los datos de la sesión (usuario, empresa, token).
  const factory AuthState.authenticated(AuthSessionEntity session) =
      AuthStateAuthenticated;

  /// No hay sesión. El usuario debe hacer login.
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
}
