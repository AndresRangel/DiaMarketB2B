// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrandEntity {

 String get id; String get name;/// FK hacia proveedor. Puede ser null si la marca no tiene proveedor asignado.
 String? get providerId; bool get isActive;
/// Create a copy of BrandEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandEntityCopyWith<BrandEntity> get copyWith => _$BrandEntityCopyWithImpl<BrandEntity>(this as BrandEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,providerId,isActive);

@override
String toString() {
  return 'BrandEntity(id: $id, name: $name, providerId: $providerId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $BrandEntityCopyWith<$Res>  {
  factory $BrandEntityCopyWith(BrandEntity value, $Res Function(BrandEntity) _then) = _$BrandEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? providerId, bool isActive
});




}
/// @nodoc
class _$BrandEntityCopyWithImpl<$Res>
    implements $BrandEntityCopyWith<$Res> {
  _$BrandEntityCopyWithImpl(this._self, this._then);

  final BrandEntity _self;
  final $Res Function(BrandEntity) _then;

/// Create a copy of BrandEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? providerId = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BrandEntity].
extension BrandEntityPatterns on BrandEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrandEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrandEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrandEntity value)  $default,){
final _that = this;
switch (_that) {
case _BrandEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrandEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BrandEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? providerId,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrandEntity() when $default != null:
return $default(_that.id,_that.name,_that.providerId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? providerId,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _BrandEntity():
return $default(_that.id,_that.name,_that.providerId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? providerId,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _BrandEntity() when $default != null:
return $default(_that.id,_that.name,_that.providerId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _BrandEntity implements BrandEntity {
  const _BrandEntity({required this.id, required this.name, this.providerId, this.isActive = true});
  

@override final  String id;
@override final  String name;
/// FK hacia proveedor. Puede ser null si la marca no tiene proveedor asignado.
@override final  String? providerId;
@override@JsonKey() final  bool isActive;

/// Create a copy of BrandEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandEntityCopyWith<_BrandEntity> get copyWith => __$BrandEntityCopyWithImpl<_BrandEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrandEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.providerId, providerId) || other.providerId == providerId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,providerId,isActive);

@override
String toString() {
  return 'BrandEntity(id: $id, name: $name, providerId: $providerId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$BrandEntityCopyWith<$Res> implements $BrandEntityCopyWith<$Res> {
  factory _$BrandEntityCopyWith(_BrandEntity value, $Res Function(_BrandEntity) _then) = __$BrandEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? providerId, bool isActive
});




}
/// @nodoc
class __$BrandEntityCopyWithImpl<$Res>
    implements _$BrandEntityCopyWith<$Res> {
  __$BrandEntityCopyWithImpl(this._self, this._then);

  final _BrandEntity _self;
  final $Res Function(_BrandEntity) _then;

/// Create a copy of BrandEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? providerId = freezed,Object? isActive = null,}) {
  return _then(_BrandEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,providerId: freezed == providerId ? _self.providerId : providerId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
