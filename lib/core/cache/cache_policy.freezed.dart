// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_policy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CachePolicy {

 CacheLifetime get lifetime; CacheLayer get layer;/// TTL personalizado. Solo aplica cuando lifetime = persistent.
/// Si es null y lifetime = persistent, el dato no expira nunca.
 Duration? get customTtl;
/// Create a copy of CachePolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CachePolicyCopyWith<CachePolicy> get copyWith => _$CachePolicyCopyWithImpl<CachePolicy>(this as CachePolicy, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CachePolicy&&(identical(other.lifetime, lifetime) || other.lifetime == lifetime)&&(identical(other.layer, layer) || other.layer == layer)&&(identical(other.customTtl, customTtl) || other.customTtl == customTtl));
}


@override
int get hashCode => Object.hash(runtimeType,lifetime,layer,customTtl);

@override
String toString() {
  return 'CachePolicy(lifetime: $lifetime, layer: $layer, customTtl: $customTtl)';
}


}

/// @nodoc
abstract mixin class $CachePolicyCopyWith<$Res>  {
  factory $CachePolicyCopyWith(CachePolicy value, $Res Function(CachePolicy) _then) = _$CachePolicyCopyWithImpl;
@useResult
$Res call({
 CacheLifetime lifetime, CacheLayer layer, Duration? customTtl
});




}
/// @nodoc
class _$CachePolicyCopyWithImpl<$Res>
    implements $CachePolicyCopyWith<$Res> {
  _$CachePolicyCopyWithImpl(this._self, this._then);

  final CachePolicy _self;
  final $Res Function(CachePolicy) _then;

/// Create a copy of CachePolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lifetime = null,Object? layer = null,Object? customTtl = freezed,}) {
  return _then(_self.copyWith(
lifetime: null == lifetime ? _self.lifetime : lifetime // ignore: cast_nullable_to_non_nullable
as CacheLifetime,layer: null == layer ? _self.layer : layer // ignore: cast_nullable_to_non_nullable
as CacheLayer,customTtl: freezed == customTtl ? _self.customTtl : customTtl // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [CachePolicy].
extension CachePolicyPatterns on CachePolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CachePolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CachePolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CachePolicy value)  $default,){
final _that = this;
switch (_that) {
case _CachePolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CachePolicy value)?  $default,){
final _that = this;
switch (_that) {
case _CachePolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CacheLifetime lifetime,  CacheLayer layer,  Duration? customTtl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CachePolicy() when $default != null:
return $default(_that.lifetime,_that.layer,_that.customTtl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CacheLifetime lifetime,  CacheLayer layer,  Duration? customTtl)  $default,) {final _that = this;
switch (_that) {
case _CachePolicy():
return $default(_that.lifetime,_that.layer,_that.customTtl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CacheLifetime lifetime,  CacheLayer layer,  Duration? customTtl)?  $default,) {final _that = this;
switch (_that) {
case _CachePolicy() when $default != null:
return $default(_that.lifetime,_that.layer,_that.customTtl);case _:
  return null;

}
}

}

/// @nodoc


class _CachePolicy implements CachePolicy {
  const _CachePolicy({required this.lifetime, required this.layer, this.customTtl});
  

@override final  CacheLifetime lifetime;
@override final  CacheLayer layer;
/// TTL personalizado. Solo aplica cuando lifetime = persistent.
/// Si es null y lifetime = persistent, el dato no expira nunca.
@override final  Duration? customTtl;

/// Create a copy of CachePolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CachePolicyCopyWith<_CachePolicy> get copyWith => __$CachePolicyCopyWithImpl<_CachePolicy>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CachePolicy&&(identical(other.lifetime, lifetime) || other.lifetime == lifetime)&&(identical(other.layer, layer) || other.layer == layer)&&(identical(other.customTtl, customTtl) || other.customTtl == customTtl));
}


@override
int get hashCode => Object.hash(runtimeType,lifetime,layer,customTtl);

@override
String toString() {
  return 'CachePolicy(lifetime: $lifetime, layer: $layer, customTtl: $customTtl)';
}


}

/// @nodoc
abstract mixin class _$CachePolicyCopyWith<$Res> implements $CachePolicyCopyWith<$Res> {
  factory _$CachePolicyCopyWith(_CachePolicy value, $Res Function(_CachePolicy) _then) = __$CachePolicyCopyWithImpl;
@override @useResult
$Res call({
 CacheLifetime lifetime, CacheLayer layer, Duration? customTtl
});




}
/// @nodoc
class __$CachePolicyCopyWithImpl<$Res>
    implements _$CachePolicyCopyWith<$Res> {
  __$CachePolicyCopyWithImpl(this._self, this._then);

  final _CachePolicy _self;
  final $Res Function(_CachePolicy) _then;

/// Create a copy of CachePolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lifetime = null,Object? layer = null,Object? customTtl = freezed,}) {
  return _then(_CachePolicy(
lifetime: null == lifetime ? _self.lifetime : lifetime // ignore: cast_nullable_to_non_nullable
as CacheLifetime,layer: null == layer ? _self.layer : layer // ignore: cast_nullable_to_non_nullable
as CacheLayer,customTtl: freezed == customTtl ? _self.customTtl : customTtl // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on
