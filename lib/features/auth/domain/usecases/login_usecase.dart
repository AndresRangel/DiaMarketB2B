import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: autenticar al usuario con sus credenciales.
///
/// Un Use Case = una operación de negocio = una clase con un método call().
/// Recibe el repositorio como dependencia (inyectado por Riverpod en Bloque 5).
///
/// El Use Case es responsable de:
///   1. Validar los datos de entrada ANTES de ir a la red
///   2. Llamar al repositorio
///   3. Retornar el resultado como Either<Failure, T>
///
/// El Use Case NO es responsable de:
///   - Saber cómo se hace la llamada HTTP (eso es el repositorio/data source)
///   - Mostrar errores al usuario (eso es el Notifier/View)
class LoginUseCase {
  final AuthRepository _repository;

  // Constructor: el repositorio llega desde afuera (inyección de dependencias).
  // En Bloque 5, Riverpod lo inyecta automáticamente.
  const LoginUseCase(this._repository);

  /// Ejecuta el caso de uso.
  ///
  /// Retorna:
  ///   - Right(AuthSessionEntity) → login exitoso
  ///   - Left(Failure) → algo salió mal (credenciales inválidas, sin red, etc.)
  Future<Either<Failure, AuthSessionEntity>> call({
    required String username,
    required String password,
    String? fcmToken,
    String? imei,
    String? companyCode,
  }) async {
    // Validación de entrada: si falla aquí, no se hace la llamada a la red
    if (username.trim().isEmpty) {
      return const Left(Failure.validation('Usuario requerido', field: 'username'));
    }
    if (password.isEmpty) {
      return const Left(Failure.validation('Contraseña requerida', field: 'password'));
    }

    return _repository.login(
      username: username.trim(),
      password: password,
      fcmToken: fcmToken,
      imei: imei,
      companyCode: companyCode,
    );
  }
}
