import '../entities/auth_session_entity.dart';
import '../entities/company_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: cambiar la empresa activa dentro de la sesión.
/// Se usa cuando el usuario tiene acceso a varias empresas y selecciona una.
/// La empresa activa determina catálogo, precios y tema visual.
class SelectCompanyUseCase {
  final AuthRepository _repository;

  const SelectCompanyUseCase(this._repository);

  /// Guarda la sesión actualizada con la nueva [company] como activa.
  /// Retorna la sesión actualizada para que el Notifier actualice su estado.
  Future<AuthSessionEntity> call({
    required AuthSessionEntity session,
    required CompanyEntity company,
  }) async {
    // copyWith es un método que genera freezed: crea una copia del objeto
    // cambiando solo los campos que indiques. El original no se modifica.
    final updatedSession = session.copyWith(selectedCompany: company);
    await _repository.updateSelectedCompany(
      session: updatedSession,
      company: company,
    );
    return updatedSession;
  }
}
