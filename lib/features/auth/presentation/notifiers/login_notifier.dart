// NOTA: Este archivo NO importa nada de Flutter (material.dart, widgets, etc.).
// Es Dart puro + Riverpod. El Notifier es el "cerebro" de la pantalla de login,
// pero no sabe nada de cómo se ve la pantalla.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/company_entity.dart';
import 'auth_notifier.dart';
import 'login_state.dart';

part 'login_notifier.g.dart';

// ── Provider del Notifier ─────────────────────────────────────────────────────

/// LoginNotifier gestiona el estado de la pantalla de login.
///
/// NO tiene keepAlive → se destruye automáticamente cuando LoginPage
/// desaparece del árbol de widgets. Eso limpia memoria y reinicia el estado.
///
/// Equivalente GetX: el LoginController que ponías en Get.put() dentro del
/// binding de la ruta /login.
@riverpod
class LoginNotifier extends _$LoginNotifier {
  /// build() retorna el estado inicial de forma síncrona.
  /// La pantalla arranca en estado "initial" (campos vacíos, ningún error).
  @override
  LoginState build() => const LoginState.initial();

  // ── Acción principal ──────────────────────────────────────────────────────

  /// Intenta hacer login con las credenciales proporcionadas.
  ///
  /// La View llama a este método cuando el usuario pulsa "Ingresar".
  /// La View NO valida los campos — esa responsabilidad es del Notifier.
  Future<void> login(String username, String password) async {
    // Validaciones en el ViewModel, NUNCA en la View.
    if (username.trim().isEmpty) {
      state = const LoginState.error('El usuario es requerido');
      return;
    }
    if (password.isEmpty) {
      state = const LoginState.error('La contraseña es requerida');
      return;
    }

    // Cambiar a estado loading: la View deshabilitará el botón y mostrará spinner.
    state = const LoginState.loading();

    // ref.read (no watch) para ejecutar una acción puntual, no suscribirse.
    // El Use Case llama al repositorio que llama al data source que llama a S01.
    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(
      username: username.trim(),
      password: password,
    );

    // result es Either<Failure, AuthSessionEntity>.
    // fold() ejecuta la función izquierda si es Left (error) o la derecha si es Right (éxito).
    state = result.fold(
      // Left → algo falló: red caída, credenciales inválidas, servidor, etc.
      (failure) => LoginState.error(failure.when(
        server: (msg, _) => msg,
        cache: (msg) => msg,
        network: (_) => 'Sin conexión. Verifica tu internet.',
        validation: (msg, _) => msg,
        unauthorized: (_) => 'Usuario o contraseña incorrectos.',
        unknown: (msg) => msg,
      )),

      // Right → login exitoso. Ahora decidimos qué flujo sigue.
      (session) {
        if (session.companies.length > 1) {
          // Múltiples empresas → la View debe mostrar un selector.
          // El Notifier NO navega ni muestra diálogos directamente.
          return LoginState.needsCompanySelection(
            session: session,
            companies: session.companies,
          );
        }

        // Una sola empresa (ya está seleccionada por LoginUseCase/repositorio).
        // Notificar al AuthNotifier global que ya hay sesión válida.
        // Esto cambiará AuthState a authenticated, lo que activará el guard
        // del router para redirigir al home.
        ref.read(authProvider.notifier).onLoginSuccess(session);
        return LoginState.success(session);
      },
    );
  }

  // ── Flujo multi-empresa ───────────────────────────────────────────────────

  /// Se llama cuando el usuario elige una empresa del selector.
  ///
  /// La View muestra el diálogo de selección cuando el estado es
  /// [LoginStateNeedsCompanySelection]. Cuando el usuario elige, llama a este método.
  Future<void> selectCompany(CompanyEntity company) async {
    final current = state;
    if (current is! LoginStateNeedsCompanySelection) return;

    // Actualizar la empresa seleccionada en la sesión.
    await ref.read(authProvider.notifier).selectCompany(company);

    // Notificar que el login está completo con la empresa elegida.
    final updatedSession = current.session.copyWith(selectedCompany: company);
    ref.read(authProvider.notifier).onLoginSuccess(updatedSession);
    state = LoginState.success(updatedSession);
  }

  // ── Utilidades ────────────────────────────────────────────────────────────

  /// Limpia el error actual y vuelve al estado inicial.
  /// Útil para limpiar el mensaje de error cuando el usuario empieza a escribir.
  void clearError() {
    if (state is LoginStateError) {
      state = const LoginState.initial();
    }
  }
}
