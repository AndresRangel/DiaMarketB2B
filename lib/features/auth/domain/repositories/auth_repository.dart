import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_session_entity.dart';
import '../entities/company_entity.dart';
import '../entities/user_entity.dart';

/// Contrato abstracto del repositorio de autenticación.
///
/// Esta interfaz define QUÉ puede hacer el sistema de auth,
/// sin decir CÓMO lo hace (eso lo decide la implementación en la capa de datos).
///
/// Ventaja: si mañana cambia la API, solo se modifica la implementación.
/// Los Use Cases y la UI no se enteran del cambio.
///
/// Equivalente GetX: era el Service que llamabas desde el Controller.
/// En Clean Architecture, el dominio define el contrato y datos lo implementa.
abstract class AuthRepository {
  // ── Operaciones de red (retornan Either<Failure, T>) ──────────────────

  /// S01 — Autentica al usuario y retorna la sesión completa.
  /// Incluye token, datos del usuario y lista de empresas disponibles.
  Future<Either<Failure, AuthSessionEntity>> login({
    required String username,
    required String password,
    String? fcmToken,
    String? imei,
    String? companyCode,
  });

  /// S02 (envío) — Solicita al servidor que reenvíe el código OTP al celular.
  /// Se usa cuando el usuario pide "reenviar código" en la pantalla de OTP.
  Future<Either<Failure, void>> sendOtp(String phone);

  /// S02 (validación) — Verifica el código OTP ingresado por el usuario.
  Future<Either<Failure, bool>> validateOtp({
    required String phone,
    required String code,
  });

  /// S03 — Inicia el flujo de recuperación de contraseña vía email o SMS.
  Future<Either<Failure, void>> recoverPassword({
    String? username,
    String? email,
  });

  /// S04 — Registra un nuevo cliente. El registro queda pendiente de aprobación.
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String password,
    required String phone,
    required String email,
    required String businessType,
    required String cityId,
    String? referralCode,
  });

  /// S05 — Registra el token FCM del dispositivo para recibir push notifications.
  /// Se llama después de cada login exitoso.
  Future<Either<Failure, void>> registerFcmToken({
    required String userId,
    required String fcmToken,
  });

  /// S06 — Solicita un nuevo token de sesión usando el token actual.
  /// Lo llama el interceptor de Dio automáticamente cuando recibe un 401.
  Future<Either<Failure, String>> refreshToken(String currentToken);

  // ── Operaciones locales (storage, no van a la red) ────────────────────

  /// Lee la sesión guardada en almacenamiento seguro.
  /// La usa SplashPage para saber si el usuario ya estaba logueado.
  /// Retorna null si no hay sesión guardada.
  Future<AuthSessionEntity?> getSavedSession();

  /// Persiste la sesión en almacenamiento seguro tras un login exitoso.
  Future<void> saveSession(AuthSessionEntity session);

  /// Borra la sesión guardada. Se llama al hacer logout o cuando el
  /// refresh token falla y no se puede renovar la sesión.
  Future<void> clearSession();

  /// Actualiza la empresa activa dentro de la sesión guardada.
  /// Se usa cuando el usuario tiene varias empresas y selecciona una diferente.
  Future<void> updateSelectedCompany({
    required AuthSessionEntity session,
    required CompanyEntity company,
  });
}
