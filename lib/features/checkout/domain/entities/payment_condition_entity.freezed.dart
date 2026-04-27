// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_condition_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaymentConditionEntity {

 String get id; String get code; String get name;/// Plazo en días. 0 = contado.
 int get days; String? get description;
/// Create a copy of PaymentConditionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentConditionEntityCopyWith<PaymentConditionEntity> get copyWith => _$PaymentConditionEntityCopyWithImpl<PaymentConditionEntity>(this as PaymentConditionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentConditionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.days, days) || other.days == days)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,name,days,description);

@override
String toString() {
  return 'PaymentConditionEntity(id: $id, code: $code, name: $name, days: $days, description: $description)';
}


}

/// @nodoc
abstract mixin class $PaymentConditionEntityCopyWith<$Res>  {
  factory $PaymentConditionEntityCopyWith(PaymentConditionEntity value, $Res Function(PaymentConditionEntity) _then) = _$PaymentConditionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, int days, String? description
});




}
/// @nodoc
class _$PaymentConditionEntityCopyWithImpl<$Res>
    implements $PaymentConditionEntityCopyWith<$Res> {
  _$PaymentConditionEntityCopyWithImpl(this._self, this._then);

  final PaymentConditionEntity _self;
  final $Res Function(PaymentConditionEntity) _then;

/// Create a copy of PaymentConditionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? days = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentConditionEntity].
extension PaymentConditionEntityPatterns on PaymentConditionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentConditionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentConditionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentConditionEntity value)  $default,){
final _that = this;
switch (_that) {
case _PaymentConditionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentConditionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentConditionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  int days,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentConditionEntity() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.days,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  int days,  String? description)  $default,) {final _that = this;
switch (_that) {
case _PaymentConditionEntity():
return $default(_that.id,_that.code,_that.name,_that.days,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  int days,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _PaymentConditionEntity() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.days,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _PaymentConditionEntity extends PaymentConditionEntity {
  const _PaymentConditionEntity({required this.id, required this.code, required this.name, this.days = 0, this.description}): super._();
  

@override final  String id;
@override final  String code;
@override final  String name;
/// Plazo en días. 0 = contado.
@override@JsonKey() final  int days;
@override final  String? description;

/// Create a copy of PaymentConditionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentConditionEntityCopyWith<_PaymentConditionEntity> get copyWith => __$PaymentConditionEntityCopyWithImpl<_PaymentConditionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentConditionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.days, days) || other.days == days)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,name,days,description);

@override
String toString() {
  return 'PaymentConditionEntity(id: $id, code: $code, name: $name, days: $days, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PaymentConditionEntityCopyWith<$Res> implements $PaymentConditionEntityCopyWith<$Res> {
  factory _$PaymentConditionEntityCopyWith(_PaymentConditionEntity value, $Res Function(_PaymentConditionEntity) _then) = __$PaymentConditionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, int days, String? description
});




}
/// @nodoc
class __$PaymentConditionEntityCopyWithImpl<$Res>
    implements _$PaymentConditionEntityCopyWith<$Res> {
  __$PaymentConditionEntityCopyWithImpl(this._self, this._then);

  final _PaymentConditionEntity _self;
  final $Res Function(_PaymentConditionEntity) _then;

/// Create a copy of PaymentConditionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? days = null,Object? description = freezed,}) {
  return _then(_PaymentConditionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
