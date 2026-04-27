// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthSessionEntity {

 UserEntity get user;/// Token JWT (o similar) que se envía en el header Authorization
 String get sessionToken;/// Todas las empresas a las que tiene acceso este usuario
 List<CompanyEntity> get companies;/// La empresa actualmente activa.
/// Si el usuario solo tiene una empresa, se selecciona automáticamente.
 CompanyEntity get selectedCompany;
/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionEntityCopyWith<AuthSessionEntity> get copyWith => _$AuthSessionEntityCopyWithImpl<AuthSessionEntity>(this as AuthSessionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSessionEntity&&(identical(other.user, user) || other.user == user)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&const DeepCollectionEquality().equals(other.companies, companies)&&(identical(other.selectedCompany, selectedCompany) || other.selectedCompany == selectedCompany));
}


@override
int get hashCode => Object.hash(runtimeType,user,sessionToken,const DeepCollectionEquality().hash(companies),selectedCompany);

@override
String toString() {
  return 'AuthSessionEntity(user: $user, sessionToken: $sessionToken, companies: $companies, selectedCompany: $selectedCompany)';
}


}

/// @nodoc
abstract mixin class $AuthSessionEntityCopyWith<$Res>  {
  factory $AuthSessionEntityCopyWith(AuthSessionEntity value, $Res Function(AuthSessionEntity) _then) = _$AuthSessionEntityCopyWithImpl;
@useResult
$Res call({
 UserEntity user, String sessionToken, List<CompanyEntity> companies, CompanyEntity selectedCompany
});


$UserEntityCopyWith<$Res> get user;$CompanyEntityCopyWith<$Res> get selectedCompany;

}
/// @nodoc
class _$AuthSessionEntityCopyWithImpl<$Res>
    implements $AuthSessionEntityCopyWith<$Res> {
  _$AuthSessionEntityCopyWithImpl(this._self, this._then);

  final AuthSessionEntity _self;
  final $Res Function(AuthSessionEntity) _then;

/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? sessionToken = null,Object? companies = null,Object? selectedCompany = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,companies: null == companies ? _self.companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyEntity>,selectedCompany: null == selectedCompany ? _self.selectedCompany : selectedCompany // ignore: cast_nullable_to_non_nullable
as CompanyEntity,
  ));
}
/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res> get user {
  
  return $UserEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyEntityCopyWith<$Res> get selectedCompany {
  
  return $CompanyEntityCopyWith<$Res>(_self.selectedCompany, (value) {
    return _then(_self.copyWith(selectedCompany: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthSessionEntity].
extension AuthSessionEntityPatterns on AuthSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuthSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserEntity user,  String sessionToken,  List<CompanyEntity> companies,  CompanyEntity selectedCompany)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSessionEntity() when $default != null:
return $default(_that.user,_that.sessionToken,_that.companies,_that.selectedCompany);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserEntity user,  String sessionToken,  List<CompanyEntity> companies,  CompanyEntity selectedCompany)  $default,) {final _that = this;
switch (_that) {
case _AuthSessionEntity():
return $default(_that.user,_that.sessionToken,_that.companies,_that.selectedCompany);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserEntity user,  String sessionToken,  List<CompanyEntity> companies,  CompanyEntity selectedCompany)?  $default,) {final _that = this;
switch (_that) {
case _AuthSessionEntity() when $default != null:
return $default(_that.user,_that.sessionToken,_that.companies,_that.selectedCompany);case _:
  return null;

}
}

}

/// @nodoc


class _AuthSessionEntity implements AuthSessionEntity {
  const _AuthSessionEntity({required this.user, required this.sessionToken, required final  List<CompanyEntity> companies, required this.selectedCompany}): _companies = companies;
  

@override final  UserEntity user;
/// Token JWT (o similar) que se envía en el header Authorization
@override final  String sessionToken;
/// Todas las empresas a las que tiene acceso este usuario
 final  List<CompanyEntity> _companies;
/// Todas las empresas a las que tiene acceso este usuario
@override List<CompanyEntity> get companies {
  if (_companies is EqualUnmodifiableListView) return _companies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_companies);
}

/// La empresa actualmente activa.
/// Si el usuario solo tiene una empresa, se selecciona automáticamente.
@override final  CompanyEntity selectedCompany;

/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSessionEntityCopyWith<_AuthSessionEntity> get copyWith => __$AuthSessionEntityCopyWithImpl<_AuthSessionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSessionEntity&&(identical(other.user, user) || other.user == user)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&const DeepCollectionEquality().equals(other._companies, _companies)&&(identical(other.selectedCompany, selectedCompany) || other.selectedCompany == selectedCompany));
}


@override
int get hashCode => Object.hash(runtimeType,user,sessionToken,const DeepCollectionEquality().hash(_companies),selectedCompany);

@override
String toString() {
  return 'AuthSessionEntity(user: $user, sessionToken: $sessionToken, companies: $companies, selectedCompany: $selectedCompany)';
}


}

/// @nodoc
abstract mixin class _$AuthSessionEntityCopyWith<$Res> implements $AuthSessionEntityCopyWith<$Res> {
  factory _$AuthSessionEntityCopyWith(_AuthSessionEntity value, $Res Function(_AuthSessionEntity) _then) = __$AuthSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 UserEntity user, String sessionToken, List<CompanyEntity> companies, CompanyEntity selectedCompany
});


@override $UserEntityCopyWith<$Res> get user;@override $CompanyEntityCopyWith<$Res> get selectedCompany;

}
/// @nodoc
class __$AuthSessionEntityCopyWithImpl<$Res>
    implements _$AuthSessionEntityCopyWith<$Res> {
  __$AuthSessionEntityCopyWithImpl(this._self, this._then);

  final _AuthSessionEntity _self;
  final $Res Function(_AuthSessionEntity) _then;

/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? sessionToken = null,Object? companies = null,Object? selectedCompany = null,}) {
  return _then(_AuthSessionEntity(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,companies: null == companies ? _self._companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyEntity>,selectedCompany: null == selectedCompany ? _self.selectedCompany : selectedCompany // ignore: cast_nullable_to_non_nullable
as CompanyEntity,
  ));
}

/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserEntityCopyWith<$Res> get user {
  
  return $UserEntityCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyEntityCopyWith<$Res> get selectedCompany {
  
  return $CompanyEntityCopyWith<$Res>(_self.selectedCompany, (value) {
    return _then(_self.copyWith(selectedCompany: value));
  });
}
}

// dart format on
