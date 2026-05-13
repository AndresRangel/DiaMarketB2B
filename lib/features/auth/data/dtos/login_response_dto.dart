import 'package:freezed_annotation/freezed_annotation.dart';

import 'company_dto.dart';
import 'user_dto.dart';

part 'login_response_dto.g.dart';
part 'login_response_dto.freezed.dart';

/// Respuesta del endpoint S01 — Supabase Auth (/auth/v1/token?grant_type=password).
@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    /// Unix timestamp (segundos) en que expira el access_token.
    @JsonKey(name: 'expires_at') required int expiresAt,
    required UserDto user,
    @Default([]) List<CompanyDto> companies,
    @JsonKey(name: 'selected_company_id') String? selectedCompanyId,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}
