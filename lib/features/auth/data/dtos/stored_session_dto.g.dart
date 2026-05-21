// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredSessionDto _$StoredSessionDtoFromJson(Map<String, dynamic> json) =>
    _StoredSessionDto(
      sessionToken: json['sessionToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: (json['expiresAt'] as num).toInt(),
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      companies: (json['companies'] as List<dynamic>)
          .map((e) => CompanyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCompanyId: json['selectedCompanyId'] as String,
      tenantId: json['tenantId'] as String?,
    );

Map<String, dynamic> _$StoredSessionDtoToJson(_StoredSessionDto instance) =>
    <String, dynamic>{
      'sessionToken': instance.sessionToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt,
      'user': instance.user,
      'companies': instance.companies,
      'selectedCompanyId': instance.selectedCompanyId,
      'tenantId': instance.tenantId,
    };
