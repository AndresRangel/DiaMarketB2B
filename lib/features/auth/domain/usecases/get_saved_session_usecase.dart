import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: leer la sesión guardada en almacenamiento seguro.
/// Lo usa SplashPage al arrancar la app para saber si el usuario
/// ya estaba logueado y saltar directamente al Home.
/// Retorna null si no hay sesión (→ ir a LoginPage).
class GetSavedSessionUseCase {
  final AuthRepository _repository;

  const GetSavedSessionUseCase(this._repository);

  Future<AuthSessionEntity?> call() => _repository.getSavedSession();
}
