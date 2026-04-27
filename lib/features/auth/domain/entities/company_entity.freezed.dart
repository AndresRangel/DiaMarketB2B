// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CompanyEntity {

 String get id;/// Código interno de la empresa en el ERP (ej. "001", "DIA")
 String get code; String get name;/// URL del logo de esta empresa — puede ser diferente al branding global
 String? get logoUrl;
/// Create a copy of CompanyEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyEntityCopyWith<CompanyEntity> get copyWith => _$CompanyEntityCopyWithImpl<CompanyEntity>(this as CompanyEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,name,logoUrl);

@override
String toString() {
  return 'CompanyEntity(id: $id, code: $code, name: $name, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class $CompanyEntityCopyWith<$Res>  {
  factory $CompanyEntityCopyWith(CompanyEntity value, $Res Function(CompanyEntity) _then) = _$CompanyEntityCopyWithImpl;
@useResult
$Res call({
 String id, String code, String name, String? logoUrl
});




}
/// @nodoc
class _$CompanyEntityCopyWithImpl<$Res>
    implements $CompanyEntityCopyWith<$Res> {
  _$CompanyEntityCopyWithImpl(this._self, this._then);

  final CompanyEntity _self;
  final $Res Function(CompanyEntity) _then;

/// Create a copy of CompanyEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? logoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyEntity].
extension CompanyEntityPatterns on CompanyEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyEntity value)  $default,){
final _that = this;
switch (_that) {
case _CompanyEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyEntity() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String name,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _CompanyEntity():
return $default(_that.id,_that.code,_that.name,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String name,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _CompanyEntity() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc


class _CompanyEntity implements CompanyEntity {
  const _CompanyEntity({required this.id, required this.code, required this.name, this.logoUrl});
  

@override final  String id;
/// Código interno de la empresa en el ERP (ej. "001", "DIA")
@override final  String code;
@override final  String name;
/// URL del logo de esta empresa — puede ser diferente al branding global
@override final  String? logoUrl;

/// Create a copy of CompanyEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyEntityCopyWith<_CompanyEntity> get copyWith => __$CompanyEntityCopyWithImpl<_CompanyEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,code,name,logoUrl);

@override
String toString() {
  return 'CompanyEntity(id: $id, code: $code, name: $name, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$CompanyEntityCopyWith<$Res> implements $CompanyEntityCopyWith<$Res> {
  factory _$CompanyEntityCopyWith(_CompanyEntity value, $Res Function(_CompanyEntity) _then) = __$CompanyEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String name, String? logoUrl
});




}
/// @nodoc
class __$CompanyEntityCopyWithImpl<$Res>
    implements _$CompanyEntityCopyWith<$Res> {
  __$CompanyEntityCopyWithImpl(this._self, this._then);

  final _CompanyEntity _self;
  final $Res Function(_CompanyEntity) _then;

/// Create a copy of CompanyEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? logoUrl = freezed,}) {
  return _then(_CompanyEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
