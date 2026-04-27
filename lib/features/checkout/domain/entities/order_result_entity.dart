import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_result_entity.freezed.dart';

/// Respuesta del backend tras crear un pedido exitoso (S19).
@freezed
abstract class OrderResultEntity with _$OrderResultEntity {
  const factory OrderResultEntity({
    required String orderId,

    /// Número visible del pedido (ej: "PED-2024-0042").
    required String orderNumber,

    /// Total confirmado por el servidor (puede diferir del calculado localmente).
    required double confirmedTotal,

    /// Mensaje de confirmación para mostrar al usuario.
    String? message,
  }) = _OrderResultEntity;
}
