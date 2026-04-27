// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_condition_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentConditionDto _$PaymentConditionDtoFromJson(Map<String, dynamic> json) =>
    _PaymentConditionDto(
      id: json['id'] as String,
      code: json['codigo'] as String,
      name: json['nombre'] as String,
      days: (json['dias'] as num?)?.toInt() ?? 0,
      description: json['descripcion'] as String?,
    );

Map<String, dynamic> _$PaymentConditionDtoToJson(
  _PaymentConditionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'codigo': instance.code,
  'nombre': instance.name,
  'dias': instance.days,
  'descripcion': instance.description,
};
