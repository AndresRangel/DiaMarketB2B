// Los DTOs (Data Transfer Objects) son los modelos de la capa de datos.
// Saben exactamente cómo luce el JSON del servidor y cómo parsearlo.
// A diferencia de las Entidades, SÍ tienen fromJson/toJson.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.g.dart';
part 'user_dto.freezed.dart';

/// Modelo de usuario tal como lo devuelve el backend.
///
/// Los nombres de campo (ej. `is_approved`) deben coincidir
/// exactamente con el JSON del servidor — ajustar cuando llegue
/// la documentación real del backend.
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String username,
    String? email,
    String? phone,
    String? role,
    // JsonKey mapea el nombre del JSON al nombre de la variable Dart.
    // Si el backend usa snake_case y Dart usa camelCase, aquí se reconcilia.
    @JsonKey(name: 'is_approved') @Default(true) bool isApproved,
  }) = _UserDto;

  /// Crea un UserDto desde un Map<String, dynamic> (el JSON deserializado).
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}
