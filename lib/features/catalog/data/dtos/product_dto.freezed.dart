// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductDto {

 String get id; String get sku; String get name;/// Acepta tanto num como String (Supabase puede devolver numeric de ambas formas).
@JsonKey(name: 'base_price', fromJson: _parsePrice) double get basePrice;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'brand_id') String? get brandId;@JsonKey(name: 'category_id') String? get categoryId;@JsonKey(name: 'tax_rule_id') int? get taxRuleId;/// Descuento como decimal (0.15 = 15%). Backend aún no lo envía → default 0.
@JsonKey(name: 'descuento', fromJson: _parsePrice) double get discount;/// Impuesto al Consumo (ICO) — valor fijo en moneda por unidad.
/// Aplica a licores. Backend lo enviará próximamente → default 0.
@JsonKey(name: 'ico_amount', fromJson: _parsePrice) double get icoAmount;@JsonKey(name: 'is_active') bool get isActive;
/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDtoCopyWith<ProductDto> get copyWith => _$ProductDtoCopyWithImpl<ProductDto>(this as ProductDto, _$identity);

  /// Serializes this ProductDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDto&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.taxRuleId, taxRuleId) || other.taxRuleId == taxRuleId)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.icoAmount, icoAmount) || other.icoAmount == icoAmount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,basePrice,imageUrl,brandId,categoryId,taxRuleId,discount,icoAmount,isActive);

@override
String toString() {
  return 'ProductDto(id: $id, sku: $sku, name: $name, basePrice: $basePrice, imageUrl: $imageUrl, brandId: $brandId, categoryId: $categoryId, taxRuleId: $taxRuleId, discount: $discount, icoAmount: $icoAmount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProductDtoCopyWith<$Res>  {
  factory $ProductDtoCopyWith(ProductDto value, $Res Function(ProductDto) _then) = _$ProductDtoCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String name,@JsonKey(name: 'base_price', fromJson: _parsePrice) double basePrice,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'brand_id') String? brandId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'tax_rule_id') int? taxRuleId,@JsonKey(name: 'descuento', fromJson: _parsePrice) double discount,@JsonKey(name: 'ico_amount', fromJson: _parsePrice) double icoAmount,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class _$ProductDtoCopyWithImpl<$Res>
    implements $ProductDtoCopyWith<$Res> {
  _$ProductDtoCopyWithImpl(this._self, this._then);

  final ProductDto _self;
  final $Res Function(ProductDto) _then;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? basePrice = null,Object? imageUrl = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? taxRuleId = freezed,Object? discount = null,Object? icoAmount = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,taxRuleId: freezed == taxRuleId ? _self.taxRuleId : taxRuleId // ignore: cast_nullable_to_non_nullable
as int?,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,icoAmount: null == icoAmount ? _self.icoAmount : icoAmount // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductDto].
extension ProductDtoPatterns on ProductDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String name, @JsonKey(name: 'base_price', fromJson: _parsePrice)  double basePrice, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'brand_id')  String? brandId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'tax_rule_id')  int? taxRuleId, @JsonKey(name: 'descuento', fromJson: _parsePrice)  double discount, @JsonKey(name: 'ico_amount', fromJson: _parsePrice)  double icoAmount, @JsonKey(name: 'is_active')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.basePrice,_that.imageUrl,_that.brandId,_that.categoryId,_that.taxRuleId,_that.discount,_that.icoAmount,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String name, @JsonKey(name: 'base_price', fromJson: _parsePrice)  double basePrice, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'brand_id')  String? brandId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'tax_rule_id')  int? taxRuleId, @JsonKey(name: 'descuento', fromJson: _parsePrice)  double discount, @JsonKey(name: 'ico_amount', fromJson: _parsePrice)  double icoAmount, @JsonKey(name: 'is_active')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProductDto():
return $default(_that.id,_that.sku,_that.name,_that.basePrice,_that.imageUrl,_that.brandId,_that.categoryId,_that.taxRuleId,_that.discount,_that.icoAmount,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String name, @JsonKey(name: 'base_price', fromJson: _parsePrice)  double basePrice, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'brand_id')  String? brandId, @JsonKey(name: 'category_id')  String? categoryId, @JsonKey(name: 'tax_rule_id')  int? taxRuleId, @JsonKey(name: 'descuento', fromJson: _parsePrice)  double discount, @JsonKey(name: 'ico_amount', fromJson: _parsePrice)  double icoAmount, @JsonKey(name: 'is_active')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProductDto() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.basePrice,_that.imageUrl,_that.brandId,_that.categoryId,_that.taxRuleId,_that.discount,_that.icoAmount,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDto implements ProductDto {
  const _ProductDto({required this.id, required this.sku, required this.name, @JsonKey(name: 'base_price', fromJson: _parsePrice) required this.basePrice, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'brand_id') this.brandId, @JsonKey(name: 'category_id') this.categoryId, @JsonKey(name: 'tax_rule_id') this.taxRuleId, @JsonKey(name: 'descuento', fromJson: _parsePrice) this.discount = 0.0, @JsonKey(name: 'ico_amount', fromJson: _parsePrice) this.icoAmount = 0.0, @JsonKey(name: 'is_active') this.isActive = true});
  factory _ProductDto.fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

@override final  String id;
@override final  String sku;
@override final  String name;
/// Acepta tanto num como String (Supabase puede devolver numeric de ambas formas).
@override@JsonKey(name: 'base_price', fromJson: _parsePrice) final  double basePrice;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'brand_id') final  String? brandId;
@override@JsonKey(name: 'category_id') final  String? categoryId;
@override@JsonKey(name: 'tax_rule_id') final  int? taxRuleId;
/// Descuento como decimal (0.15 = 15%). Backend aún no lo envía → default 0.
@override@JsonKey(name: 'descuento', fromJson: _parsePrice) final  double discount;
/// Impuesto al Consumo (ICO) — valor fijo en moneda por unidad.
/// Aplica a licores. Backend lo enviará próximamente → default 0.
@override@JsonKey(name: 'ico_amount', fromJson: _parsePrice) final  double icoAmount;
@override@JsonKey(name: 'is_active') final  bool isActive;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDtoCopyWith<_ProductDto> get copyWith => __$ProductDtoCopyWithImpl<_ProductDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDto&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.taxRuleId, taxRuleId) || other.taxRuleId == taxRuleId)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.icoAmount, icoAmount) || other.icoAmount == icoAmount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sku,name,basePrice,imageUrl,brandId,categoryId,taxRuleId,discount,icoAmount,isActive);

@override
String toString() {
  return 'ProductDto(id: $id, sku: $sku, name: $name, basePrice: $basePrice, imageUrl: $imageUrl, brandId: $brandId, categoryId: $categoryId, taxRuleId: $taxRuleId, discount: $discount, icoAmount: $icoAmount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProductDtoCopyWith<$Res> implements $ProductDtoCopyWith<$Res> {
  factory _$ProductDtoCopyWith(_ProductDto value, $Res Function(_ProductDto) _then) = __$ProductDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String name,@JsonKey(name: 'base_price', fromJson: _parsePrice) double basePrice,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'brand_id') String? brandId,@JsonKey(name: 'category_id') String? categoryId,@JsonKey(name: 'tax_rule_id') int? taxRuleId,@JsonKey(name: 'descuento', fromJson: _parsePrice) double discount,@JsonKey(name: 'ico_amount', fromJson: _parsePrice) double icoAmount,@JsonKey(name: 'is_active') bool isActive
});




}
/// @nodoc
class __$ProductDtoCopyWithImpl<$Res>
    implements _$ProductDtoCopyWith<$Res> {
  __$ProductDtoCopyWithImpl(this._self, this._then);

  final _ProductDto _self;
  final $Res Function(_ProductDto) _then;

/// Create a copy of ProductDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? basePrice = null,Object? imageUrl = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? taxRuleId = freezed,Object? discount = null,Object? icoAmount = null,Object? isActive = null,}) {
  return _then(_ProductDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,brandId: freezed == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,taxRuleId: freezed == taxRuleId ? _self.taxRuleId : taxRuleId // ignore: cast_nullable_to_non_nullable
as int?,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,icoAmount: null == icoAmount ? _self.icoAmount : icoAmount // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
