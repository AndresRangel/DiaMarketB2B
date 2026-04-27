import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/get_saved_session_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/recover_password_usecase.dart';
import '../../domain/usecases/register_fcm_token_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/select_company_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/validate_otp_usecase.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

// ── Providers de Use Cases ────────────────────────────────────────────────────
// Cada provider instancia su Use Case inyectándole el repositorio.
// Los Notifiers los consumen con ref.read(loginUseCaseProvider), etc.

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetSavedSessionUseCase getSavedSessionUseCase(Ref ref) =>
    GetSavedSessionUseCase(ref.watch(authRepositoryProvider));

@riverpod
SelectCompanyUseCase selectCompanyUseCase(Ref ref) =>
    SelectCompanyUseCase(ref.watch(authRepositoryProvider));

@riverpod
ValidateOtpUseCase validateOtpUseCase(Ref ref) =>
    ValidateOtpUseCase(ref.watch(authRepositoryProvider));

@riverpod
SendOtpUseCase sendOtpUseCase(Ref ref) =>
    SendOtpUseCase(ref.watch(authRepositoryProvider));

@riverpod
RecoverPasswordUseCase recoverPasswordUseCase(Ref ref) =>
    RecoverPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase registerUseCase(Ref ref) =>
    RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterFcmTokenUseCase registerFcmTokenUseCase(Ref ref) =>
    RegisterFcmTokenUseCase(ref.watch(authRepositoryProvider));

// ── AuthNotifier ──────────────────────────────────────────────────────────────

/// Notifier global de autenticación.
///
/// keepAlive: true → vive durante TODA la app. Nunca se destruye.
/// Es la fuente de verdad sobre si el usuario está autenticado o no.
///
/// Equivalente GetX: el AuthController que ponías en Get.put() en main.dart.
/// En Riverpod, Riverpod lo crea automáticamente la primera vez que alguien
/// hace ref.watch(authNotifierProvider).
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  /// build() es el "constructor" de Riverpod.
  /// Retorna el estado inicial de forma síncrona.
  /// La verificación real de sesión la hace initialize(), llamada desde SplashPage.
  @override
  AuthState build() => const AuthState.initial();

  /// Verifica si hay una sesión guardada al arrancar la app.
  /// SplashPage llama a este método y luego navega según el resultado.
  Future<void> initialize() async {
    // ref.read (no watch) porque solo queremos ejecutar la acción,
    // no reconstruir el notifier cuando el use case cambie.
    final useCase = ref.read(getSavedSessionUseCaseProvider);
    final session = await useCase();

    state = session != null
        ? AuthState.authenticated(session)
        : const AuthState.unauthenticated();
  }

  /// Actualiza el estado a autenticado tras un login exitoso.
  /// Lo llama LoginNotifier después de que LoginUseCase retorna Right(session).
  void onLoginSuccess(AuthSessionEntity session) {
    state = AuthState.authenticated(session);
  }

  /// Cambia la empresa activa dentro de la sesión actual.
  /// Lo llama el CompanySelectorDialog cuando el usuario elige una empresa.
  Future<void> selectCompany(CompanyEntity company) async {
    // El switch en Dart 3 obliga a manejar todos los casos de la sealed class.
    // Si el estado no es authenticated, no hay nada que cambiar.
    final current = state;
    if (current is! AuthStateAuthenticated) return;

    final useCase = ref.read(selectCompanyUseCaseProvider);
    final updatedSession = await useCase(
      session: current.session,
      company: company,
    );
    state = AuthState.authenticated(updatedSession);
  }

  /// Cierra sesión: borra el storage local y pone el estado en unauthenticated.
  /// El router detecta el cambio y redirige automáticamente a LoginPage.
  Future<void> logout() async {
    final useCase = ref.read(logoutUseCaseProvider);
    await useCase();
    state = const AuthState.unauthenticated();
  }

  // ── Getters de conveniencia ─────────────────────────────────────────────

  bool get isLoggedIn => state is AuthStateAuthenticated;

  /// Retorna la sesión activa, o null si no está autenticado.
  AuthSessionEntity? get currentSession => switch (state) {
        AuthStateAuthenticated(:final session) => session,
        _ => null,
      };
}
