// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrandDto _$BrandDtoFromJson(Map<String, dynamic> json) => _BrandDto(
  id: json['id'] as String,
  name: json['name'] as String,
  providerId: json['provider_id'] as String?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$BrandDtoToJson(_BrandDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'provider_id': instance.providerId,
  'is_active': instance.isActive,
};
