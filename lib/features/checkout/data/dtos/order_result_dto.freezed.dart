// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderResultDto {

@JsonKey(name: 'id_pedido') String get orderId;@JsonKey(name: 'numero_pedido') String get orderNumber;@JsonKey(name: 'total_confirmado') double get confirmedTotal;@JsonKey(name: 'mensaje') String? get message;
/// Create a copy of OrderResultDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderResultDtoCopyWith<OrderResultDto> get copyWith => _$OrderResultDtoCopyWithImpl<OrderResultDto>(this as OrderResultDto, _$identity);

  /// Serializes this OrderResultDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderResultDto&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.confirmedTotal, confirmedTotal) || other.confirmedTotal == confirmedTotal)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,orderNumber,confirmedTotal,message);

@override
String toString() {
  return 'OrderResultDto(orderId: $orderId, orderNumber: $orderNumber, confirmedTotal: $confirmedTotal, message: $message)';
}


}

/// @nodoc
abstract mixin class $OrderResultDtoCopyWith<$Res>  {
  factory $OrderResultDtoCopyWith(OrderResultDto value, $Res Function(OrderResultDto) _then) = _$OrderResultDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id_pedido') String orderId,@JsonKey(name: 'numero_pedido') String orderNumber,@JsonKey(name: 'total_confirmado') double confirmedTotal,@JsonKey(name: 'mensaje') String? message
});




}
/// @nodoc
class _$OrderResultDtoCopyWithImpl<$Res>
    implements $OrderResultDtoCopyWith<$Res> {
  _$OrderResultDtoCopyWithImpl(this._self, this._then);

  final OrderResultDto _self;
  final $Res Function(OrderResultDto) _then;

/// Create a copy of OrderResultDto
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


/// Adds pattern-matching-related methods to [OrderResultDto].
extension OrderResultDtoPatterns on OrderResultDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderResultDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderResultDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderResultDto value)  $default,){
final _that = this;
switch (_that) {
case _OrderResultDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderResultDto value)?  $default,){
final _that = this;
switch (_that) {
case _OrderResultDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_pedido')  String orderId, @JsonKey(name: 'numero_pedido')  String orderNumber, @JsonKey(name: 'total_confirmado')  double confirmedTotal, @JsonKey(name: 'mensaje')  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderResultDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id_pedido')  String orderId, @JsonKey(name: 'numero_pedido')  String orderNumber, @JsonKey(name: 'total_confirmado')  double confirmedTotal, @JsonKey(name: 'mensaje')  String? message)  $default,) {final _that = this;
switch (_that) {
case _OrderResultDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id_pedido')  String orderId, @JsonKey(name: 'numero_pedido')  String orderNumber, @JsonKey(name: 'total_confirmado')  double confirmedTotal, @JsonKey(name: 'mensaje')  String? message)?  $default,) {final _that = this;
switch (_that) {
case _OrderResultDto() when $default != null:
return $default(_that.orderId,_that.orderNumber,_that.confirmedTotal,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderResultDto implements OrderResultDto {
  const _OrderResultDto({@JsonKey(name: 'id_pedido') required this.orderId, @JsonKey(name: 'numero_pedido') required this.orderNumber, @JsonKey(name: 'total_confirmado') required this.confirmedTotal, @JsonKey(name: 'mensaje') this.message});
  factory _OrderResultDto.fromJson(Map<String, dynamic> json) => _$OrderResultDtoFromJson(json);

@override@JsonKey(name: 'id_pedido') final  String orderId;
@override@JsonKey(name: 'numero_pedido') final  String orderNumber;
@override@JsonKey(name: 'total_confirmado') final  double confirmedTotal;
@override@JsonKey(name: 'mensaje') final  String? message;

/// Create a copy of OrderResultDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderResultDtoCopyWith<_OrderResultDto> get copyWith => __$OrderResultDtoCopyWithImpl<_OrderResultDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderResultDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderResultDto&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.confirmedTotal, confirmedTotal) || other.confirmedTotal == confirmedTotal)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orderId,orderNumber,confirmedTotal,message);

@override
String toString() {
  return 'OrderResultDto(orderId: $orderId, orderNumber: $orderNumber, confirmedTotal: $confirmedTotal, message: $message)';
}


}

/// @nodoc
abstract mixin class _$OrderResultDtoCopyWith<$Res> implements $OrderResultDtoCopyWith<$Res> {
  factory _$OrderResultDtoCopyWith(_OrderResultDto value, $Res Function(_OrderResultDto) _then) = __$OrderResultDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id_pedido') String orderId,@JsonKey(name: 'numero_pedido') String orderNumber,@JsonKey(name: 'total_confirmado') double confirmedTotal,@JsonKey(name: 'mensaje') String? message
});




}
/// @nodoc
class __$OrderResultDtoCopyWithImpl<$Res>
    implements _$OrderResultDtoCopyWith<$Res> {
  __$OrderResultDtoCopyWithImpl(this._self, this._then);

  final _OrderResultDto _self;
  final $Res Function(_OrderResultDto) _then;

/// Create a copy of OrderResultDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderNumber = null,Object? confirmedTotal = null,Object? message = freezed,}) {
  return _then(_OrderResultDto(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,confirmedTotal: null == confirmedTotal ? _self.confirmedTotal : confirmedTotal // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
