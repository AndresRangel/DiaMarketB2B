// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_creation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderCreationEntity {

 String get branchId; String get paymentConditionId; List<OrderLineEntity> get lines;/// Código de cupón aplicado (Fase 4). Null si no hay.
 String? get couponCode;/// Notas o comentarios del cliente.
 String? get notes;
/// Create a copy of OrderCreationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCreationEntityCopyWith<OrderCreationEntity> get copyWith => _$OrderCreationEntityCopyWithImpl<OrderCreationEntity>(this as OrderCreationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderCreationEntity&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.paymentConditionId, paymentConditionId) || other.paymentConditionId == paymentConditionId)&&const DeepCollectionEquality().equals(other.lines, lines)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,branchId,paymentConditionId,const DeepCollectionEquality().hash(lines),couponCode,notes);

@override
String toString() {
  return 'OrderCreationEntity(branchId: $branchId, paymentConditionId: $paymentConditionId, lines: $lines, couponCode: $couponCode, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $OrderCreationEntityCopyWith<$Res>  {
  factory $OrderCreationEntityCopyWith(OrderCreationEntity value, $Res Function(OrderCreationEntity) _then) = _$OrderCreationEntityCopyWithImpl;
@useResult
$Res call({
 String branchId, String paymentConditionId, List<OrderLineEntity> lines, String? couponCode, String? notes
});




}
/// @nodoc
class _$OrderCreationEntityCopyWithImpl<$Res>
    implements $OrderCreationEntityCopyWith<$Res> {
  _$OrderCreationEntityCopyWithImpl(this._self, this._then);

  final OrderCreationEntity _self;
  final $Res Function(OrderCreationEntity) _then;

/// Create a copy of OrderCreationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? branchId = null,Object? paymentConditionId = null,Object? lines = null,Object? couponCode = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,paymentConditionId: null == paymentConditionId ? _self.paymentConditionId : paymentConditionId // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLineEntity>,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderCreationEntity].
extension OrderCreationEntityPatterns on OrderCreationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderCreationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderCreationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderCreationEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderCreationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderCreationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderCreationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String branchId,  String paymentConditionId,  List<OrderLineEntity> lines,  String? couponCode,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderCreationEntity() when $default != null:
return $default(_that.branchId,_that.paymentConditionId,_that.lines,_that.couponCode,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String branchId,  String paymentConditionId,  List<OrderLineEntity> lines,  String? couponCode,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _OrderCreationEntity():
return $default(_that.branchId,_that.paymentConditionId,_that.lines,_that.couponCode,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String branchId,  String paymentConditionId,  List<OrderLineEntity> lines,  String? couponCode,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _OrderCreationEntity() when $default != null:
return $default(_that.branchId,_that.paymentConditionId,_that.lines,_that.couponCode,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _OrderCreationEntity extends OrderCreationEntity {
  const _OrderCreationEntity({required this.branchId, required this.paymentConditionId, required final  List<OrderLineEntity> lines, this.couponCode, this.notes}): _lines = lines,super._();
  

@override final  String branchId;
@override final  String paymentConditionId;
 final  List<OrderLineEntity> _lines;
@override List<OrderLineEntity> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

/// Código de cupón aplicado (Fase 4). Null si no hay.
@override final  String? couponCode;
/// Notas o comentarios del cliente.
@override final  String? notes;

/// Create a copy of OrderCreationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCreationEntityCopyWith<_OrderCreationEntity> get copyWith => __$OrderCreationEntityCopyWithImpl<_OrderCreationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderCreationEntity&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.paymentConditionId, paymentConditionId) || other.paymentConditionId == paymentConditionId)&&const DeepCollectionEquality().equals(other._lines, _lines)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,branchId,paymentConditionId,const DeepCollectionEquality().hash(_lines),couponCode,notes);

@override
String toString() {
  return 'OrderCreationEntity(branchId: $branchId, paymentConditionId: $paymentConditionId, lines: $lines, couponCode: $couponCode, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$OrderCreationEntityCopyWith<$Res> implements $OrderCreationEntityCopyWith<$Res> {
  factory _$OrderCreationEntityCopyWith(_OrderCreationEntity value, $Res Function(_OrderCreationEntity) _then) = __$OrderCreationEntityCopyWithImpl;
@override @useResult
$Res call({
 String branchId, String paymentConditionId, List<OrderLineEntity> lines, String? couponCode, String? notes
});




}
/// @nodoc
class __$OrderCreationEntityCopyWithImpl<$Res>
    implements _$OrderCreationEntityCopyWith<$Res> {
  __$OrderCreationEntityCopyWithImpl(this._self, this._then);

  final _OrderCreationEntity _self;
  final $Res Function(_OrderCreationEntity) _then;

/// Create a copy of OrderCreationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? branchId = null,Object? paymentConditionId = null,Object? lines = null,Object? couponCode = freezed,Object? notes = freezed,}) {
  return _then(_OrderCreationEntity(
branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,paymentConditionId: null == paymentConditionId ? _self.paymentConditionId : paymentConditionId // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<OrderLineEntity>,couponCode: freezed == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
