// Las entidades de dominio son modelos puros de negocio.
// NO tienen fromJson/toJson — eso es responsabilidad de los DTOs en la capa de datos.
// Son inmutables gracias a freezed: una vez creadas, no se modifican, se reemplazan.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// Representa al usuario autenticado en el sistema.
///
/// Este modelo vive en el dominio, por eso no sabe nada de JSON, de red,
/// ni de base de datos. Es el "usuario" según las reglas de negocio.
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String username,
    String? email,
    String? phone,
    String? role,
    String? fullName,
    @Default(true) bool isApproved,
  }) = _UserEntity;
}
