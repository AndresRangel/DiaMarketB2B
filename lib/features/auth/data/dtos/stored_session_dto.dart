import 'package:freezed_annotation/freezed_annotation.dart';

import 'company_dto.dart';
import 'user_dto.dart';

part 'stored_session_dto.g.dart';
part 'stored_session_dto.freezed.dart';

/// DTO para persistir la sesión en SecureStorage.
///
/// SecureStorage solo puede guardar Strings, así que la sesión
/// se serializa a JSON con este DTO y se guarda como String.
///
/// Al releer, se deserializa y se convierte a AuthSessionEntity
/// con el mapper correspondiente.
@freezed
abstract class StoredSessionDto with _$StoredSessionDto {
  const factory StoredSessionDto({
    required String sessionToken,
    required UserDto user,
    required List<CompanyDto> companies,
    /// ID de la empresa actualmente seleccionada — puede cambiar
    /// si el usuario elige otra empresa durante la sesión.
    required String selectedCompanyId,
  }) = _StoredSessionDto;

  factory StoredSessionDto.fromJson(Map<String, dynamic> json) =>
      _$StoredSessionDtoFromJson(json);
}
