import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

/// Producto del catálogo según las reglas de negocio.
///
/// Sin JSON, sin Dio, sin Hive. Solo datos de negocio.
/// Viene de public.products_v en Supabase.
///
/// Tax rules (campo [taxRuleId]):
///   1 → IVA 19% (general)
///   2 → IVA  5%
///   3 → IVA  0% (exento)
@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required String id,

    /// Código único del producto en el ERP.
    required String sku,

    required String name,

    /// Precio base antes de IVA, ICO y descuentos.
    required double basePrice,

    /// URL completa de la imagen desde el CDN de Supabase.
    String? imageUrl,

    /// FK hacia [BrandEntity].
    String? brandId,

    /// FK hacia [CategoryEntity].
    String? categoryId,

    /// Regla de impuesto: 1=IVA 19%, 2=IVA 5%, 3=IVA 0%.
    int? taxRuleId,

    /// Descuento del producto como decimal (0.15 = 15%).
    /// Viene del backend cuando hay promoción activa en la lista de precios.
    @Default(0.0) double discount,

    /// Impuesto al Consumo (ICO) — valor fijo en moneda por unidad.
    /// Aplica principalmente a licores y bebidas alcohólicas.
    /// El backend lo enviará cuando esté disponible; por ahora llega en 0.
    @Default(0.0) double icoAmount,

    @Default(true) bool isActive,
  }) = _ProductEntity;

  const ProductEntity._();

  /// Porcentaje de IVA según la regla de impuesto.
  double get taxRate => switch (taxRuleId) {
        1 => 0.19,
        2 => 0.05,
        _ => 0.00,
      };

  /// Valor del IVA calculado sobre el precio base.
  double get taxAmount => basePrice * taxRate;

  /// Valor del descuento en moneda (basePrice × discount).
  double get discountAmount => basePrice * discount;

  /// Precio final al consumidor: base + IVA + ICO − descuento.
  double get finalPrice =>
      basePrice + taxAmount + icoAmount - discountAmount;
}
