import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_dto.g.dart';
part 'product_dto.freezed.dart';

/// Convierte base_price a double sin importar si llega como num o String.
/// Supabase puede devolver numeric como String ("10000.0000") o como num (10000.0).
double _parsePrice(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Modelo de producto tal como lo devuelve Supabase (public.products_v).
///
/// Diferencia clave con ProductEntity:
///   - Tiene fromJson/toJson (sabe sobre JSON)
///   - NO tiene getters de negocio (taxRate, finalPrice, etc.)
@freezed
abstract class ProductDto with _$ProductDto {
  const factory ProductDto({
    required String id,
    required String sku,
    required String name,

    /// Acepta tanto num como String (Supabase puede devolver numeric de ambas formas).
    @JsonKey(name: 'base_price', fromJson: _parsePrice) required double basePrice,

    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'brand_id') String? brandId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'tax_rule_id') int? taxRuleId,

    /// Descuento como decimal (0.15 = 15%). Backend aún no lo envía → default 0.
    @JsonKey(name: 'descuento', fromJson: _parsePrice)
    @Default(0.0)
    double discount,

    /// Impuesto al Consumo (ICO) — valor fijo en moneda por unidad.
    /// Aplica a licores. Backend lo enviará próximamente → default 0.
    @JsonKey(name: 'ico_amount', fromJson: _parsePrice)
    @Default(0.0)
    double icoAmount,

    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}
