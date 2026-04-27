// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => _ProductDto(
  id: json['id'] as String,
  sku: json['sku'] as String,
  name: json['name'] as String,
  basePrice: _parsePrice(json['base_price']),
  imageUrl: json['image_url'] as String?,
  brandId: json['brand_id'] as String?,
  categoryId: json['category_id'] as String?,
  taxRuleId: (json['tax_rule_id'] as num?)?.toInt(),
  discount: json['descuento'] == null ? 0.0 : _parsePrice(json['descuento']),
  icoAmount: json['ico_amount'] == null ? 0.0 : _parsePrice(json['ico_amount']),
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$ProductDtoToJson(_ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'base_price': instance.basePrice,
      'image_url': instance.imageUrl,
      'brand_id': instance.brandId,
      'category_id': instance.categoryId,
      'tax_rule_id': instance.taxRuleId,
      'descuento': instance.discount,
      'ico_amount': instance.icoAmount,
      'is_active': instance.isActive,
    };
