import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: validar el código OTP ingresado por el usuario.
/// Si retorna Right(true) → OTP válido, continuar al Home.
/// Si retorna Right(false) → OTP inválido, mostrar error.
class ValidateOtpUseCase {
  final AuthRepository _repository;

  const ValidateOtpUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required String phone,
    required String code,
  }) async {
    if (phone.trim().isEmpty) {
      return const Left(Failure.validation('Teléfono requerido', field: 'phone'));
    }
    // El OTP es siempre de 6 dígitos según la spec (sección 13 del CLAUDE.md)
    if (code.length != 6) {
      return const Left(Failure.validation('El código debe tener 6 dígitos', field: 'code'));
    }
    return _repository.validateOtp(phone: phone.trim(), code: code);
  }
}
