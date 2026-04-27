// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchDto _$BranchDtoFromJson(Map<String, dynamic> json) => _BranchDto(
  id: json['id'] as String,
  code: json['codigo'] as String,
  name: json['nombre'] as String,
  address: json['direccion'] as String?,
  city: json['ciudad'] as String?,
  phone: json['telefono'] as String?,
  priceListId: json['id_lista_precios'] as String?,
  isDefault: json['es_principal'] as bool? ?? false,
);

Map<String, dynamic> _$BranchDtoToJson(_BranchDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.code,
      'nombre': instance.name,
      'direccion': instance.address,
      'ciudad': instance.city,
      'telefono': instance.phone,
      'id_lista_precios': instance.priceListId,
      'es_principal': instance.isDefault,
    };
