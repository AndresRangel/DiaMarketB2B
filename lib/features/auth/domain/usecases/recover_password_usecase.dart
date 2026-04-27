import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: iniciar el flujo de recuperación de contraseña (S03).
/// El servidor envía un email o SMS con instrucciones.
/// Se requiere al menos uno: username o email.
class RecoverPasswordUseCase {
  final AuthRepository _repository;

  const RecoverPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call({
    String? username,
    String? email,
  }) async {
    final hasUsername = username != null && username.trim().isNotEmpty;
    final hasEmail = email != null && email.trim().isNotEmpty;

    if (!hasUsername && !hasEmail) {
      return const Left(
        Failure.validation('Ingresa tu usuario o correo electrónico'),
      );
    }

    return _repository.recoverPassword(
      username: hasUsername ? username.trim() : null,
      email: hasEmail ? email.trim() : null,
    );
  }
}
