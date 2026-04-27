// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_result_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderResultEntity {

 String get orderId;/// Número visible del pedido (ej: "PED-2024-0042").
 String get orderNumber;/// Total confirmado por el servidor (puede diferir del calculado localmente).
 double get confirmedTotal;/// Mensaje de confirmación para mostrar al usuario.
 String? get message;
/// Create a copy of OrderResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderResultEntityCopyWith<OrderResultEntity> get copyWith => _$OrderResultEntityCopyWithImpl<OrderResultEntity>(this as OrderResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderResultEntity&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.confirmedTotal, confirmedTotal) || other.confirmedTotal == confirmedTotal)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderNumber,confirmedTotal,message);

@override
String toString() {
  return 'OrderResultEntity(orderId: $orderId, orderNumber: $orderNumber, confirmedTotal: $confirmedTotal, message: $message)';
}


}

/// @nodoc
abstract mixin class $OrderResultEntityCopyWith<$Res>  {
  factory $OrderResultEntityCopyWith(OrderResultEntity value, $Res Function(OrderResultEntity) _then) = _$OrderResultEntityCopyWithImpl;
@useResult
$Res call({
 String orderId, String orderNumber, double confirmedTotal, String? message
});




}
/// @nodoc
class _$OrderResultEntityCopyWithImpl<$Res>
    implements $OrderResultEntityCopyWith<$Res> {
  _$OrderResultEntityCopyWithImpl(this._self, this._then);

  final OrderResultEntity _self;
  final $Res Function(OrderResultEntity) _then;

/// Create a copy of OrderResultEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? orderNumber = null,Object? confirmedTotal = null,Object? message = freezed,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,confirmedTotal: null == confirmedTotal ? _self.confirmedTotal : confirmedTotal // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderResultEntity].
extension OrderResultEntityPatterns on OrderResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderResultEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orderId,  String orderNumber,  double confirmedTotal,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderResultEntity() when $default != null:
return $default(_that.orderId,_that.orderNumber,_that.confirmedTotal,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orderId,  String orderNumber,  double confirmedTotal,  String? message)  $default,) {final _that = this;
switch (_that) {
case _OrderResultEntity():
return $default(_that.orderId,_that.orderNumber,_that.confirmedTotal,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orderId,  String orderNumber,  double confirmedTotal,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _OrderResultEntity() when $default != null:
return $default(_that.orderId,_that.orderNumber,_that.confirmedTotal,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _OrderResultEntity implements OrderResultEntity {
  const _OrderResultEntity({required this.orderId, required this.orderNumber, required this.confirmedTotal, this.message});
  

@override final  String orderId;
/// Número visible del pedido (ej: "PED-2024-0042").
@override final  String orderNumber;
/// Total confirmado por el servidor (puede diferir del calculado localmente).
@override final  double confirmedTotal;
/// Mensaje de confirmación para mostrar al usuario.
@override final  String? message;

/// Create a copy of OrderResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderResultEntityCopyWith<_OrderResultEntity> get copyWith => __$OrderResultEntityCopyWithImpl<_OrderResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderResultEntity&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.confirmedTotal, confirmedTotal) || other.confirmedTotal == confirmedTotal)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderNumber,confirmedTotal,message);

@override
String toString() {
  return 'OrderResultEntity(orderId: $orderId, orderNumber: $orderNumber, confirmedTotal: $confirmedTotal, message: $message)';
}


}

/// @nodoc
abstract mixin class _$OrderResultEntityCopyWith<$Res> implements $OrderResultEntityCopyWith<$Res> {
  factory _$OrderResultEntityCopyWith(_OrderResultEntity value, $Res Function(_OrderResultEntity) _then) = __$OrderResultEntityCopyWithImpl;
@override @useResult
$Res call({
 String orderId, String orderNumber, double confirmedTotal, String? message
});




}
/// @nodoc
class __$OrderResultEntityCopyWithImpl<$Res>
    implements _$OrderResultEntityCopyWith<$Res> {
  __$OrderResultEntityCopyWithImpl(this._self, this._then);

  final _OrderResultEntity _self;
  final $Res Function(_OrderResultEntity) _then;

/// Create a copy of OrderResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderNumber = null,Object? confirmedTotal = null,Object? message = freezed,}) {
  return _then(_OrderResultEntity(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,confirmedTotal: null == confirmedTotal ? _self.confirmedTotal : confirmedTotal // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
