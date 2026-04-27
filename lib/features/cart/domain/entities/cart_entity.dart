import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item_entity.dart';

part 'cart_entity.freezed.dart';

@freezed
abstract class CartEntity with _$CartEntity {
  const factory CartEntity({
    @Default([]) List<CartItemEntity> items,
    String? couponCode,
    @Default(0.0) double couponDiscount,
  }) = _CartEntity;

  const CartEntity._();

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  /// Subtotal sin impuestos ni descuentos.
  double get totalBruto =>
      items.fold(0.0, (s, i) => s + i.lineBaseTotal);

  /// IVA total de todos los ítems.
  double get totalIVA =>
      items.fold(0.0, (s, i) => s + i.lineTaxTotal);

  /// ICO (Impuesto al Consumo) total — licores y similares.
  double get totalICO =>
      items.fold(0.0, (s, i) => s + i.lineIcoTotal);

  /// Descuentos de producto (promociones por ítem).
  double get totalProductDiscounts =>
      items.fold(0.0, (s, i) => s + i.lineDiscountTotal);

  /// Total descuentos = descuentos de producto + cupón.
  double get totalDescuentos => totalProductDiscounts + couponDiscount;

  /// Total final = bruto + IVA + ICO − descuentos.
  double get totalOrden =>
      totalBruto + totalIVA + totalICO - totalDescuentos;

  int quantityOf(String sku) =>
      items.where((i) => i.sku == sku).map((i) => i.quantity).firstOrNull ?? 0;

  bool contains(String sku) => items.any((i) => i.sku == sku);
}
