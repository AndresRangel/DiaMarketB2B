import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_line_entity.dart';

part 'order_creation_entity.freezed.dart';

/// Payload completo para crear un pedido (S19).
///
/// Se construye combinando [CartEntity] + selecciones del checkout
/// (sucursal, condición de pago).
@freezed
abstract class OrderCreationEntity with _$OrderCreationEntity {
  const factory OrderCreationEntity({
    required String branchId,
    required String paymentConditionId,
    required List<OrderLineEntity> lines,

    /// Código de cupón aplicado (Fase 4). Null si no hay.
    String? couponCode,

    /// Notas o comentarios del cliente.
    String? notes,
  }) = _OrderCreationEntity;

  const OrderCreationEntity._();

  double get totalBruto =>
      lines.fold(0.0, (s, l) => s + l.lineBaseTotal);
  double get totalIVA =>
      lines.fold(0.0, (s, l) => s + l.lineTaxTotal);
  double get totalDescuentos =>
      lines.fold(0.0, (s, l) => s + l.discount * l.quantity);
  double get totalOrden => totalBruto + totalIVA - totalDescuentos;
}
