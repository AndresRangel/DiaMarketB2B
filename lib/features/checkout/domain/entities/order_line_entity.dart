import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_line_entity.freezed.dart';

/// Línea de un pedido (un producto con su cantidad y precios).
///
/// Se construye desde [CartItemEntity] al momento de confirmar el pedido.
/// Los precios se validan contra el backend en S19.
@freezed
abstract class OrderLineEntity with _$OrderLineEntity {
  const factory OrderLineEntity({
    required String sku,
    required String productName,
    required int quantity,

    /// Precio base sin IVA (snapshot al momento del pedido).
    required double basePrice,

    /// Tasa de IVA como decimal (0.19, 0.05, 0.0).
    required double taxRate,

    /// ICO (Impuesto al Consumo) — valor fijo en moneda por unidad.
    @Default(0.0) double icoAmount,

    /// Descuento aplicado (cupón o promoción).
    @Default(0.0) double discount,
  }) = _OrderLineEntity;

  const OrderLineEntity._();

  double get taxAmount => basePrice * taxRate;
  double get discountAmount => discount;
  double get unitFinalPrice =>
      basePrice + taxAmount + icoAmount - discountAmount;
  double get lineTotal => unitFinalPrice * quantity;
  double get lineTaxTotal => taxAmount * quantity;
  double get lineBaseTotal => basePrice * quantity;
  double get lineIcoTotal => icoAmount * quantity;
  double get lineDiscountTotal => discountAmount * quantity;
}
