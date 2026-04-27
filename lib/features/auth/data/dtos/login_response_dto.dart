import 'package:freezed_annotation/freezed_annotation.dart';

import 'company_dto.dart';
import 'user_dto.dart';

part 'login_response_dto.g.dart';
part 'login_response_dto.freezed.dart';

/// Respuesta completa del endpoint S01 — Login.
///
/// Estructura placeholder — ajustar cuando llegue la documentación real.
/// Campos esperados basados en la especificación del CLAUDE.md (sección 10):
///   userData, sessionToken, listaEmpresas[]
@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    @JsonKey(name: 'session_token') required String sessionToken,
    required UserDto user,
    required List<CompanyDto> companies,
    /// ID de la empresa que el backend sugiere seleccionar por defecto.
    /// Si es null, la app selecciona la primera de la lista.
    @JsonKey(name: 'selected_company_id') String? selectedCompanyId,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
