// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) =>
    _LoginResponseDto(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: (json['expires_at'] as num).toInt(),
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      companies:
          (json['companies'] as List<dynamic>?)
              ?.map((e) => CompanyDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedCompanyId: json['selected_company_id'] as String?,
    );

Map<String, dynamic> _$LoginResponseDtoToJson(_LoginResponseDto instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_at': instance.expiresAt,
      'user': instance.user,
      'companies': instance.companies,
      'selected_company_id': instance.selectedCompanyId,
    };
