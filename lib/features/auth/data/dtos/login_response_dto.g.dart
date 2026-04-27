// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) =>
    _LoginResponseDto(
      sessionToken: json['session_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      companies: (json['companies'] as List<dynamic>)
          .map((e) => CompanyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCompanyId: json['selected_company_id'] as String?,
    );

Map<String, dynamic> _$LoginResponseDtoToJson(_LoginResponseDto instance) =>
    <String, dynamic>{
      'session_token': instance.sessionToken,
      'user': instance.user,
      'companies': instance.companies,
      'selected_company_id': instance.selectedCompanyId,
    };
