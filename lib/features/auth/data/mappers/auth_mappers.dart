import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../dtos/company_dto.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/stored_session_dto.dart';
import '../dtos/user_dto.dart';

/// Mappers: convierten DTOs (capa de datos) en Entities (capa de dominio).
///
/// Se implementan como extension methods para poder escribir:
///   dto.toEntity()
/// en lugar de:
///   AuthMapper.toEntity(dto)
///
/// Los Entities del dominio NO saben que estos mappers existen.
/// Solo los usan los repositorios de la capa de datos.

extension UserDtoMapper on UserDto {
  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        phone: phone,
        role: role,
        isApproved: isApproved,
      );
}

extension CompanyDtoMapper on CompanyDto {
  CompanyEntity toEntity() => CompanyEntity(
        id: id,
        code: code,
        name: name,
        logoUrl: logoUrl,
      );
}

extension LoginResponseDtoMapper on LoginResponseDto {
  AuthSessionEntity toEntity() {
    final companyEntities = companies.map((c) => c.toEntity()).toList();

    // Busca la empresa sugerida por el backend, o usa la primera de la lista.
    final selected = selectedCompanyId != null
        ? companyEntities.firstWhere(
            (c) => c.id == selectedCompanyId,
            orElse: () => companyEntities.first,
          )
        : companyEntities.first;

    return AuthSessionEntity(
      user: user.toEntity(),
      sessionToken: sessionToken,
      companies: companyEntities,
      selectedCompany: selected,
    );
  }
}

/// Convierte StoredSessionDto (leído de SecureStorage) → AuthSessionEntity.
extension StoredSessionDtoMapper on StoredSessionDto {
  AuthSessionEntity toEntity() {
    final companyEntities = companies.map((c) => c.toEntity()).toList();
    final selected = companyEntities.firstWhere(
      (c) => c.id == selectedCompanyId,
      orElse: () => companyEntities.first,
    );
    return AuthSessionEntity(
      user: user.toEntity(),
      sessionToken: sessionToken,
      companies: companyEntities,
      selectedCompany: selected,
    );
  }
}

/// Convierte AuthSessionEntity → StoredSessionDto para persistir en SecureStorage.
extension AuthSessionEntityMapper on AuthSessionEntity {
  StoredSessionDto toStoredDto() => StoredSessionDto(
        sessionToken: sessionToken,
        user: UserDto(
          id: user.id,
          username: user.username,
          email: user.email,
          phone: user.phone,
          role: user.role,
          isApproved: user.isApproved,
        ),
        companies: companies
            .map((c) => CompanyDto(
                  id: c.id,
                  code: c.code,
                  name: c.name,
                  logoUrl: c.logoUrl,
                ))
            .toList(),
        selectedCompanyId: selectedCompany.id,
      );
}
