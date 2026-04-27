// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoredSessionDto {

 String get sessionToken; UserDto get user; List<CompanyDto> get companies;/// ID de la empresa actualmente seleccionada — puede cambiar
/// si el usuario elige otra empresa durante la sesión.
 String get selectedCompanyId;
/// Create a copy of StoredSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredSessionDtoCopyWith<StoredSessionDto> get copyWith => _$StoredSessionDtoCopyWithImpl<StoredSessionDto>(this as StoredSessionDto, _$identity);

  /// Serializes this StoredSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredSessionDto&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.companies, companies)&&(identical(other.selectedCompanyId, selectedCompanyId) || other.selectedCompanyId == selectedCompanyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionToken,user,const DeepCollectionEquality().hash(companies),selectedCompanyId);

@override
String toString() {
  return 'StoredSessionDto(sessionToken: $sessionToken, user: $user, companies: $companies, selectedCompanyId: $selectedCompanyId)';
}


}

/// @nodoc
abstract mixin class $StoredSessionDtoCopyWith<$Res>  {
  factory $StoredSessionDtoCopyWith(StoredSessionDto value, $Res Function(StoredSessionDto) _then) = _$StoredSessionDtoCopyWithImpl;
@useResult
$Res call({
 String sessionToken, UserDto user, List<CompanyDto> companies, String selectedCompanyId
});


$UserDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$StoredSessionDtoCopyWithImpl<$Res>
    implements $StoredSessionDtoCopyWith<$Res> {
  _$StoredSessionDtoCopyWithImpl(this._self, this._then);

  final StoredSessionDto _self;
  final $Res Function(StoredSessionDto) _then;

/// Create a copy of StoredSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionToken = null,Object? user = null,Object? companies = null,Object? selectedCompanyId = null,}) {
  return _then(_self.copyWith(
sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto,companies: null == companies ? _self.companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyDto>,selectedCompanyId: null == selectedCompanyId ? _self.selectedCompanyId : selectedCompanyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of StoredSessionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get user {
  
  return $UserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoredSessionDto].
extension StoredSessionDtoPatterns on StoredSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _StoredSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoredSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionToken,  UserDto user,  List<CompanyDto> companies,  String selectedCompanyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredSessionDto() when $default != null:
return $default(_that.sessionToken,_that.user,_that.companies,_that.selectedCompanyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionToken,  UserDto user,  List<CompanyDto> companies,  String selectedCompanyId)  $default,) {final _that = this;
switch (_that) {
case _StoredSessionDto():
return $default(_that.sessionToken,_that.user,_that.companies,_that.selectedCompanyId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionToken,  UserDto user,  List<CompanyDto> companies,  String selectedCompanyId)?  $default,) {final _that = this;
switch (_that) {
case _StoredSessionDto() when $default != null:
return $default(_that.sessionToken,_that.user,_that.companies,_that.selectedCompanyId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoredSessionDto implements StoredSessionDto {
  const _StoredSessionDto({required this.sessionToken, required this.user, required final  List<CompanyDto> companies, required this.selectedCompanyId}): _companies = companies;
  factory _StoredSessionDto.fromJson(Map<String, dynamic> json) => _$StoredSessionDtoFromJson(json);

@override final  String sessionToken;
@override final  UserDto user;
 final  List<CompanyDto> _companies;
@override List<CompanyDto> get companies {
  if (_companies is EqualUnmodifiableListView) return _companies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_companies);
}

/// ID de la empresa actualmente seleccionada — puede cambiar
/// si el usuario elige otra empresa durante la sesión.
@override final  String selectedCompanyId;

/// Create a copy of StoredSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredSessionDtoCopyWith<_StoredSessionDto> get copyWith => __$StoredSessionDtoCopyWithImpl<_StoredSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredSessionDto&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._companies, _companies)&&(identical(other.selectedCompanyId, selectedCompanyId) || other.selectedCompanyId == selectedCompanyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionToken,user,const DeepCollectionEquality().hash(_companies),selectedCompanyId);

@override
String toString() {
  return 'StoredSessionDto(sessionToken: $sessionToken, user: $user, companies: $companies, selectedCompanyId: $selectedCompanyId)';
}


}

/// @nodoc
abstract mixin class _$StoredSessionDtoCopyWith<$Res> implements $StoredSessionDtoCopyWith<$Res> {
  factory _$StoredSessionDtoCopyWith(_StoredSessionDto value, $Res Function(_StoredSessionDto) _then) = __$StoredSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionToken, UserDto user, List<CompanyDto> companies, String selectedCompanyId
});


@override $UserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$StoredSessionDtoCopyWithImpl<$Res>
    implements _$StoredSessionDtoCopyWith<$Res> {
  __$StoredSessionDtoCopyWithImpl(this._self, this._then);

  final _StoredSessionDto _self;
  final $Res Function(_StoredSessionDto) _then;

/// Create a copy of StoredSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionToken = null,Object? user = null,Object? companies = null,Object? selectedCompanyId = null,}) {
  return _then(_StoredSessionDto(
sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto,companies: null == companies ? _self._companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyDto>,selectedCompanyId: null == selectedCompanyId ? _self.selectedCompanyId : selectedCompanyId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of StoredSessionDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get user {
  
  return $UserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
