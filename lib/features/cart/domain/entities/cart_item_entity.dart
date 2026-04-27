import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_entity.freezed.dart';

/// Ítem dentro del carrito de compras.
///
/// Captura precio, IVA, ICO y descuento al momento de agregar —
/// así el carrito refleja los precios de la sesión actual.
@freezed
abstract class CartItemEntity with _$CartItemEntity {
  const factory CartItemEntity({
    required String sku,
    required String name,
    String? imageUrl,
    required double basePrice,
    required double taxRate,

    /// ICO (Impuesto al Consumo) — valor fijo en moneda por unidad.
    @Default(0.0) double icoAmount,

    /// Descuento del producto como decimal (0.15 = 15%).
    @Default(0.0) double discount,

    @Default(1) int quantity,
  }) = _CartItemEntity;

  const CartItemEntity._();

  double get taxAmount => basePrice * taxRate;
  double get discountAmount => basePrice * discount;

  /// Precio unitario final: base + IVA + ICO − descuento.
  double get unitFinalPrice =>
      basePrice + taxAmount + icoAmount - discountAmount;

  double get lineTotal => unitFinalPrice * quantity;
  double get lineTaxTotal => taxAmount * quantity;
  double get lineBaseTotal => basePrice * quantity;
  double get lineIcoTotal => icoAmount * quantity;
  double get lineDiscountTotal => discountAmount * quantity;
}
