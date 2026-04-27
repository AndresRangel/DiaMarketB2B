import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: pre-registro de un nuevo cliente (S04).
/// El registro queda en estado "pendiente de aprobación" hasta que
/// el distribuidor lo apruebe manualmente. La app lleva al usuario
/// a PendingApprovalPage tras un registro exitoso.
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String username,
    required String password,
    required String phone,
    required String email,
    required String businessType,
    required String cityId,
    String? referralCode,
  }) async {
    if (username.trim().isEmpty) {
      return const Left(Failure.validation('Usuario requerido', field: 'username'));
    }
    if (password.length < 4) {
      return const Left(Failure.validation('Contraseña muy corta', field: 'password'));
    }
    if (phone.trim().isEmpty) {
      return const Left(Failure.validation('Teléfono requerido', field: 'phone'));
    }
    if (email.trim().isEmpty) {
      return const Left(Failure.validation('Correo requerido', field: 'email'));
    }

    return _repository.register(
      username: username.trim(),
      password: password,
      phone: phone.trim(),
      email: email.trim(),
      businessType: businessType,
      cityId: cityId,
      referralCode: referralCode,
    );
  }
}
