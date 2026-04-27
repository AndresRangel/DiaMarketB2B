// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderResultDto _$OrderResultDtoFromJson(Map<String, dynamic> json) =>
    _OrderResultDto(
      orderId: json['id_pedido'] as String,
      orderNumber: json['numero_pedido'] as String,
      confirmedTotal: (json['total_confirmado'] as num).toDouble(),
      message: json['mensaje'] as String?,
    );

Map<String, dynamic> _$OrderResultDtoToJson(_OrderResultDto instance) =>
    <String, dynamic>{
      'id_pedido': instance.orderId,
      'numero_pedido': instance.orderNumber,
      'total_confirmado': instance.confirmedTotal,
      'mensaje': instance.message,
    };
