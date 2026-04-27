import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: solicitar reenvío del código OTP al celular del usuario.
/// Se usa en la pantalla OTP cuando el usuario toca "Reenviar código".
class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  Future<Either<Failure, void>> call(String phone) async {
    if (phone.trim().isEmpty) {
      return const Left(Failure.validation('Teléfono requerido', field: 'phone'));
    }
    return _repository.sendOtp(phone.trim());
  }
}
