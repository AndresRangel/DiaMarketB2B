import 'package:freezed_annotation/freezed_annotation.dart';

import 'company_entity.dart';
import 'user_entity.dart';

part 'auth_session_entity.freezed.dart';

/// Representa el estado completo de una sesión autenticada.
///
/// Se crea después de un login exitoso y agrupa todo lo necesario
/// para que la app funcione: quién es el usuario, en qué empresa
/// está trabajando y el token para hacer requests autenticadas.
///
/// Diferencia clave:
///   - [user] → quién eres (no cambia durante la sesión)
///   - [selectedCompany] → en qué contexto estás trabajando
///     (cambia si el usuario selecciona otra empresa)
@freezed
abstract class AuthSessionEntity with _$AuthSessionEntity {
  const factory AuthSessionEntity({
    required UserEntity user,

    /// Access token JWT — va en el header Authorization de cada request.
    required String sessionToken,

    /// Refresh token — se usa para renovar el access token cuando expira.
    required String refreshToken,

    /// Unix timestamp (segundos) en que expira el access token.
    required int expiresAt,

    /// Todas las empresas a las que tiene acceso este usuario.
    required List<CompanyEntity> companies,

    /// La empresa actualmente activa.
    required CompanyEntity selectedCompany,
  }) = _AuthSessionEntity;
}
