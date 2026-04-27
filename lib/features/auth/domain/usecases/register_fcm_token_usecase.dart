import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: registrar el token FCM del dispositivo (S05).
/// Se llama después de cada login exitoso para que el servidor
/// pueda enviar push notifications a este dispositivo.
class RegisterFcmTokenUseCase {
  final AuthRepository _repository;

  const RegisterFcmTokenUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String fcmToken,
  }) async {
    if (fcmToken.trim().isEmpty) return const Right(null);
    return _repository.registerFcmToken(userId: userId, fcmToken: fcmToken);
  }
}
