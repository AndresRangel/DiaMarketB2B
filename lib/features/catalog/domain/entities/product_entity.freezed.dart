// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEntity {

 String get id;/// Código único del producto en el ERP.
 String get sku; String get name;/// Precio base antes de IVA, ICO y descuentos.
 double get basePrice;/// URL completa de la imagen desde el CDN de Supabase.
 String? get imageUrl;/// FK hacia [BrandEntity].
 String? get brandId;/// FK hacia [CategoryEntity].
 String? get categoryId;/// Regla de impuesto: 1=IVA 19%, 2=IVA 5%, 3=IVA 0%.
 int? get taxRuleId;/// Descuento del producto como decimal (0.15 = 15%).
/// Viene del backend cuando hay promoción activa en la lista de precios.
 double get discount;/// Impuesto al Consumo (ICO) — valor fijo en moneda por unidad.
/// Aplica principalmente a licores y bebidas alcohólicas.
/// El backend lo enviará cuando esté disponible; por ahora llega en 0.
 double get icoAmount; bool get isActive;
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<ProductEntity> get copyWith => _$ProductEntityCopyWithImpl<ProductEntity>(this as ProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.taxRuleId, taxRuleId) || other.taxRuleId == taxRuleId)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.icoAmount, icoAmount) || other.icoAmount == icoAmount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,sku,name,basePrice,imageUrl,brandId,categoryId,taxRuleId,discount,icoAmount,isActive);

@override
String toString() {
  return 'ProductEntity(id: $id, sku: $sku, name: $name, basePrice: $basePrice, imageUrl: $imageUrl, brandId: $brandId, categoryId: $categoryId, taxRuleId: $taxRuleId, discount: $discount, icoAmount: $icoAmount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProductEntityCopyWith<$Res>  {
  factory $ProductEntityCopyWith(ProductEntity value, $Res Function(ProductEntity) _then) = _$ProductEntityCopyWithImpl;
@useResult
$Res call({
 String id, String sku, String name, double basePrice, String? imageUrl, String? brandId, String? categoryId, int? taxRuleId, double discount, double icoAmount, bool isActive
});




}
/// @nodoc
class _$ProductEntityCopyWithImpl<$Res>
    implements $ProductEntityCopyWith<$Res> {
  _$ProductEntityCopyWithImpl(this._self, this._then);

  final ProductEntity _self;
  final $Res Function(ProductEntity) _then;

/// Create a copy of ProductEntity
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


/// Adds pattern-matching-related methods to [ProductEntity].
extension ProductEntityPatterns on ProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  double basePrice,  String? imageUrl,  String? brandId,  String? categoryId,  int? taxRuleId,  double discount,  double icoAmount,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sku,  String name,  double basePrice,  String? imageUrl,  String? brandId,  String? categoryId,  int? taxRuleId,  double discount,  double icoAmount,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sku,  String name,  double basePrice,  String? imageUrl,  String? brandId,  String? categoryId,  int? taxRuleId,  double discount,  double icoAmount,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.sku,_that.name,_that.basePrice,_that.imageUrl,_that.brandId,_that.categoryId,_that.taxRuleId,_that.discount,_that.icoAmount,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _ProductEntity extends ProductEntity {
  const _ProductEntity({required this.id, required this.sku, required this.name, required this.basePrice, this.imageUrl, this.brandId, this.categoryId, this.taxRuleId, this.discount = 0.0, this.icoAmount = 0.0, this.isActive = true}): super._();
  

@override final  String id;
/// Código único del producto en el ERP.
@override final  String sku;
@override final  String name;
/// Precio base antes de IVA, ICO y descuentos.
@override final  double basePrice;
/// URL completa de la imagen desde el CDN de Supabase.
@override final  String? imageUrl;
/// FK hacia [BrandEntity].
@override final  String? brandId;
/// FK hacia [CategoryEntity].
@override final  String? categoryId;
/// Regla de impuesto: 1=IVA 19%, 2=IVA 5%, 3=IVA 0%.
@override final  int? taxRuleId;
/// Descuento del producto como decimal (0.15 = 15%).
/// Viene del backend cuando hay promoción activa en la lista de precios.
@override@JsonKey() final  double discount;
/// Impuesto al Consumo (ICO) — valor fijo en moneda por unidad.
/// Aplica principalmente a licores y bebidas alcohólicas.
/// El backend lo enviará cuando esté disponible; por ahora llega en 0.
@override@JsonKey() final  double icoAmount;
@override@JsonKey() final  bool isActive;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductEntityCopyWith<_ProductEntity> get copyWith => __$ProductEntityCopyWithImpl<_ProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.taxRuleId, taxRuleId) || other.taxRuleId == taxRuleId)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.icoAmount, icoAmount) || other.icoAmount == icoAmount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,sku,name,basePrice,imageUrl,brandId,categoryId,taxRuleId,discount,icoAmount,isActive);

@override
String toString() {
  return 'ProductEntity(id: $id, sku: $sku, name: $name, basePrice: $basePrice, imageUrl: $imageUrl, brandId: $brandId, categoryId: $categoryId, taxRuleId: $taxRuleId, discount: $discount, icoAmount: $icoAmount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProductEntityCopyWith<$Res> implements $ProductEntityCopyWith<$Res> {
  factory _$ProductEntityCopyWith(_ProductEntity value, $Res Function(_ProductEntity) _then) = __$ProductEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String sku, String name, double basePrice, String? imageUrl, String? brandId, String? categoryId, int? taxRuleId, double discount, double icoAmount, bool isActive
});




}
/// @nodoc
class __$ProductEntityCopyWithImpl<$Res>
    implements _$ProductEntityCopyWith<$Res> {
  __$ProductEntityCopyWithImpl(this._self, this._then);

  final _ProductEntity _self;
  final $Res Function(_ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sku = null,Object? name = null,Object? basePrice = null,Object? imageUrl = freezed,Object? brandId = freezed,Object? categoryId = freezed,Object? taxRuleId = freezed,Object? discount = null,Object? icoAmount = null,Object? isActive = null,}) {
  return _then(_ProductEntity(
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
