import '../repositories/auth_repository.dart';

/// Caso de uso: cerrar sesión.
/// Solo borra la sesión guardada localmente — no hace llamada a red
/// (el backend no tiene endpoint de logout en los servicios definidos).
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<void> call() => _repository.clearSession();
}
