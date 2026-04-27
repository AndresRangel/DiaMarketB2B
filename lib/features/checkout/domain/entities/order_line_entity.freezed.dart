// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_line_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderLineEntity {

 String get sku; String get productName; int get quantity;/// Precio base sin IVA (snapshot al momento del pedido).
 double get basePrice;/// Tasa de IVA como decimal (0.19, 0.05, 0.0).
 double get taxRate;/// ICO (Impuesto al Consumo) — valor fijo en moneda por unidad.
 double get icoAmount;/// Descuento aplicado (cupón o promoción).
 double get discount;
/// Create a copy of OrderLineEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineEntityCopyWith<OrderLineEntity> get copyWith => _$OrderLineEntityCopyWithImpl<OrderLineEntity>(this as OrderLineEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineEntity&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.icoAmount, icoAmount) || other.icoAmount == icoAmount)&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,sku,productName,quantity,basePrice,taxRate,icoAmount,discount);

@override
String toString() {
  return 'OrderLineEntity(sku: $sku, productName: $productName, quantity: $quantity, basePrice: $basePrice, taxRate: $taxRate, icoAmount: $icoAmount, discount: $discount)';
}


}

/// @nodoc
abstract mixin class $OrderLineEntityCopyWith<$Res>  {
  factory $OrderLineEntityCopyWith(OrderLineEntity value, $Res Function(OrderLineEntity) _then) = _$OrderLineEntityCopyWithImpl;
@useResult
$Res call({
 String sku, String productName, int quantity, double basePrice, double taxRate, double icoAmount, double discount
});




}
/// @nodoc
class _$OrderLineEntityCopyWithImpl<$Res>
    implements $OrderLineEntityCopyWith<$Res> {
  _$OrderLineEntityCopyWithImpl(this._self, this._then);

  final OrderLineEntity _self;
  final $Res Function(OrderLineEntity) _then;

/// Create a copy of OrderLineEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? productName = null,Object? quantity = null,Object? basePrice = null,Object? taxRate = null,Object? icoAmount = null,Object? discount = null,}) {
  return _then(_self.copyWith(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,icoAmount: null == icoAmount ? _self.icoAmount : icoAmount // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLineEntity].
extension OrderLineEntityPatterns on OrderLineEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLineEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLineEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLineEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderLineEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLineEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLineEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String productName,  int quantity,  double basePrice,  double taxRate,  double icoAmount,  double discount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineEntity() when $default != null:
return $default(_that.sku,_that.productName,_that.quantity,_that.basePrice,_that.taxRate,_that.icoAmount,_that.discount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String productName,  int quantity,  double basePrice,  double taxRate,  double icoAmount,  double discount)  $default,) {final _that = this;
switch (_that) {
case _OrderLineEntity():
return $default(_that.sku,_that.productName,_that.quantity,_that.basePrice,_that.taxRate,_that.icoAmount,_that.discount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String productName,  int quantity,  double basePrice,  double taxRate,  double icoAmount,  double discount)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineEntity() when $default != null:
return $default(_that.sku,_that.productName,_that.quantity,_that.basePrice,_that.taxRate,_that.icoAmount,_that.discount);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLineEntity extends OrderLineEntity {
  const _OrderLineEntity({required this.sku, required this.productName, required this.quantity, required this.basePrice, required this.taxRate, this.icoAmount = 0.0, this.discount = 0.0}): super._();
  

@override final  String sku;
@override final  String productName;
@override final  int quantity;
/// Precio base sin IVA (snapshot al momento del pedido).
@override final  double basePrice;
/// Tasa de IVA como decimal (0.19, 0.05, 0.0).
@override final  double taxRate;
/// ICO (Impuesto al Consumo) — valor fijo en moneda por unidad.
@override@JsonKey() final  double icoAmount;
/// Descuento aplicado (cupón o promoción).
@override@JsonKey() final  double discount;

/// Create a copy of OrderLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineEntityCopyWith<_OrderLineEntity> get copyWith => __$OrderLineEntityCopyWithImpl<_OrderLineEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineEntity&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.basePrice, basePrice) || other.basePrice == basePrice)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.icoAmount, icoAmount) || other.icoAmount == icoAmount)&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,sku,productName,quantity,basePrice,taxRate,icoAmount,discount);

@override
String toString() {
  return 'OrderLineEntity(sku: $sku, productName: $productName, quantity: $quantity, basePrice: $basePrice, taxRate: $taxRate, icoAmount: $icoAmount, discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$OrderLineEntityCopyWith<$Res> implements $OrderLineEntityCopyWith<$Res> {
  factory _$OrderLineEntityCopyWith(_OrderLineEntity value, $Res Function(_OrderLineEntity) _then) = __$OrderLineEntityCopyWithImpl;
@override @useResult
$Res call({
 String sku, String productName, int quantity, double basePrice, double taxRate, double icoAmount, double discount
});




}
/// @nodoc
class __$OrderLineEntityCopyWithImpl<$Res>
    implements _$OrderLineEntityCopyWith<$Res> {
  __$OrderLineEntityCopyWithImpl(this._self, this._then);

  final _OrderLineEntity _self;
  final $Res Function(_OrderLineEntity) _then;

/// Create a copy of OrderLineEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? productName = null,Object? quantity = null,Object? basePrice = null,Object? taxRate = null,Object? icoAmount = null,Object? discount = null,}) {
  return _then(_OrderLineEntity(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,basePrice: null == basePrice ? _self.basePrice : basePrice // ignore: cast_nullable_to_non_nullable
as double,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,icoAmount: null == icoAmount ? _self.icoAmount : icoAmount // ignore: cast_nullable_to_non_nullable
as double,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
