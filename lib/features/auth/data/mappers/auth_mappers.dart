import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../dtos/company_dto.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/stored_session_dto.dart';
import '../dtos/user_dto.dart';

extension UserDtoMapper on UserDto {
  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        phone: phone,
        role: role,
        fullName: fullName,
        isApproved: isApproved,
        tenantId: tenantId,
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

    final selected = companyEntities.isNotEmpty
        ? (selectedCompanyId != null
            ? companyEntities.firstWhere(
                (c) => c.id == selectedCompanyId,
                orElse: () => companyEntities.first,
              )
            : companyEntities.first)
        : CompanyEntity(id: 'default', code: 'DEFAULT', name: 'Mi Empresa');

    return AuthSessionEntity(
      user: user.toEntity(),
      sessionToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      companies: companyEntities.isNotEmpty ? companyEntities : [selected],
      selectedCompany: selected,
      tenantId: user.tenantId,
    );
  }
}

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
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      companies: companyEntities,
      selectedCompany: selected,
      tenantId: tenantId,
    );
  }
}

extension AuthSessionEntityMapper on AuthSessionEntity {
  StoredSessionDto toStoredDto() => StoredSessionDto(
        sessionToken: sessionToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        user: UserDto(
          id: user.id,
          username: user.username,
          email: user.email,
          phone: user.phone,
          role: user.role,
          fullName: user.fullName,
          isApproved: user.isApproved,
          tenantId: user.tenantId,
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
        tenantId: tenantId,
      );
}
