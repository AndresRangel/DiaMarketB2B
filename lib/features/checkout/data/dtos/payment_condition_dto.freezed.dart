// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_condition_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentConditionDto {

 String get id;@JsonKey(name: 'codigo') String get code;@JsonKey(name: 'nombre') String get name;@JsonKey(name: 'dias') int get days;@JsonKey(name: 'descripcion') String? get description;
/// Create a copy of PaymentConditionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentConditionDtoCopyWith<PaymentConditionDto> get copyWith => _$PaymentConditionDtoCopyWithImpl<PaymentConditionDto>(this as PaymentConditionDto, _$identity);

  /// Serializes this PaymentConditionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentConditionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.days, days) || other.days == days)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,days,description);

@override
String toString() {
  return 'PaymentConditionDto(id: $id, code: $code, name: $name, days: $days, description: $description)';
}


}

/// @nodoc
abstract mixin class $PaymentConditionDtoCopyWith<$Res>  {
  factory $PaymentConditionDtoCopyWith(PaymentConditionDto value, $Res Function(PaymentConditionDto) _then) = _$PaymentConditionDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'codigo') String code,@JsonKey(name: 'nombre') String name,@JsonKey(name: 'dias') int days,@JsonKey(name: 'descripcion') String? description
});




}
/// @nodoc
class _$PaymentConditionDtoCopyWithImpl<$Res>
    implements $PaymentConditionDtoCopyWith<$Res> {
  _$PaymentConditionDtoCopyWithImpl(this._self, this._then);

  final PaymentConditionDto _self;
  final $Res Function(PaymentConditionDto) _then;

/// Create a copy of PaymentConditionDto
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


/// Adds pattern-matching-related methods to [PaymentConditionDto].
extension PaymentConditionDtoPatterns on PaymentConditionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentConditionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentConditionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentConditionDto value)  $default,){
final _that = this;
switch (_that) {
case _PaymentConditionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentConditionDto value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentConditionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'codigo')  String code, @JsonKey(name: 'nombre')  String name, @JsonKey(name: 'dias')  int days, @JsonKey(name: 'descripcion')  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentConditionDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'codigo')  String code, @JsonKey(name: 'nombre')  String name, @JsonKey(name: 'dias')  int days, @JsonKey(name: 'descripcion')  String? description)  $default,) {final _that = this;
switch (_that) {
case _PaymentConditionDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'codigo')  String code, @JsonKey(name: 'nombre')  String name, @JsonKey(name: 'dias')  int days, @JsonKey(name: 'descripcion')  String? description)?  $default,) {final _that = this;
switch (_that) {
case _PaymentConditionDto() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.days,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentConditionDto implements PaymentConditionDto {
  const _PaymentConditionDto({required this.id, @JsonKey(name: 'codigo') required this.code, @JsonKey(name: 'nombre') required this.name, @JsonKey(name: 'dias') this.days = 0, @JsonKey(name: 'descripcion') this.description});
  factory _PaymentConditionDto.fromJson(Map<String, dynamic> json) => _$PaymentConditionDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'codigo') final  String code;
@override@JsonKey(name: 'nombre') final  String name;
@override@JsonKey(name: 'dias') final  int days;
@override@JsonKey(name: 'descripcion') final  String? description;

/// Create a copy of PaymentConditionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentConditionDtoCopyWith<_PaymentConditionDto> get copyWith => __$PaymentConditionDtoCopyWithImpl<_PaymentConditionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentConditionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentConditionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.days, days) || other.days == days)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,days,description);

@override
String toString() {
  return 'PaymentConditionDto(id: $id, code: $code, name: $name, days: $days, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PaymentConditionDtoCopyWith<$Res> implements $PaymentConditionDtoCopyWith<$Res> {
  factory _$PaymentConditionDtoCopyWith(_PaymentConditionDto value, $Res Function(_PaymentConditionDto) _then) = __$PaymentConditionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'codigo') String code,@JsonKey(name: 'nombre') String name,@JsonKey(name: 'dias') int days,@JsonKey(name: 'descripcion') String? description
});




}
/// @nodoc
class __$PaymentConditionDtoCopyWithImpl<$Res>
    implements _$PaymentConditionDtoCopyWith<$Res> {
  __$PaymentConditionDtoCopyWithImpl(this._self, this._then);

  final _PaymentConditionDto _self;
  final $Res Function(_PaymentConditionDto) _then;

/// Create a copy of PaymentConditionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? days = null,Object? description = freezed,}) {
  return _then(_PaymentConditionDto(
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
