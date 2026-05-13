// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginResponseDto {

@JsonKey(name: 'access_token') String get accessToken;@JsonKey(name: 'refresh_token') String get refreshToken;/// Unix timestamp (segundos) en que expira el access_token.
@JsonKey(name: 'expires_at') int get expiresAt; UserDto get user; List<CompanyDto> get companies;@JsonKey(name: 'selected_company_id') String? get selectedCompanyId;
/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseDtoCopyWith<LoginResponseDto> get copyWith => _$LoginResponseDtoCopyWithImpl<LoginResponseDto>(this as LoginResponseDto, _$identity);

  /// Serializes this LoginResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.companies, companies)&&(identical(other.selectedCompanyId, selectedCompanyId) || other.selectedCompanyId == selectedCompanyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt,user,const DeepCollectionEquality().hash(companies),selectedCompanyId);

@override
String toString() {
  return 'LoginResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt, user: $user, companies: $companies, selectedCompanyId: $selectedCompanyId)';
}


}

/// @nodoc
abstract mixin class $LoginResponseDtoCopyWith<$Res>  {
  factory $LoginResponseDtoCopyWith(LoginResponseDto value, $Res Function(LoginResponseDto) _then) = _$LoginResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'expires_at') int expiresAt, UserDto user, List<CompanyDto> companies,@JsonKey(name: 'selected_company_id') String? selectedCompanyId
});


$UserDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$LoginResponseDtoCopyWithImpl<$Res>
    implements $LoginResponseDtoCopyWith<$Res> {
  _$LoginResponseDtoCopyWithImpl(this._self, this._then);

  final LoginResponseDto _self;
  final $Res Function(LoginResponseDto) _then;

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,Object? user = null,Object? companies = null,Object? selectedCompanyId = freezed,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto,companies: null == companies ? _self.companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyDto>,selectedCompanyId: freezed == selectedCompanyId ? _self.selectedCompanyId : selectedCompanyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get user {
  
  return $UserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginResponseDto].
extension LoginResponseDtoPatterns on LoginResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _LoginResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_at')  int expiresAt,  UserDto user,  List<CompanyDto> companies, @JsonKey(name: 'selected_company_id')  String? selectedCompanyId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt,_that.user,_that.companies,_that.selectedCompanyId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_at')  int expiresAt,  UserDto user,  List<CompanyDto> companies, @JsonKey(name: 'selected_company_id')  String? selectedCompanyId)  $default,) {final _that = this;
switch (_that) {
case _LoginResponseDto():
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt,_that.user,_that.companies,_that.selectedCompanyId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'access_token')  String accessToken, @JsonKey(name: 'refresh_token')  String refreshToken, @JsonKey(name: 'expires_at')  int expiresAt,  UserDto user,  List<CompanyDto> companies, @JsonKey(name: 'selected_company_id')  String? selectedCompanyId)?  $default,) {final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresAt,_that.user,_that.companies,_that.selectedCompanyId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginResponseDto implements LoginResponseDto {
  const _LoginResponseDto({@JsonKey(name: 'access_token') required this.accessToken, @JsonKey(name: 'refresh_token') required this.refreshToken, @JsonKey(name: 'expires_at') required this.expiresAt, required this.user, final  List<CompanyDto> companies = const [], @JsonKey(name: 'selected_company_id') this.selectedCompanyId}): _companies = companies;
  factory _LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);

@override@JsonKey(name: 'access_token') final  String accessToken;
@override@JsonKey(name: 'refresh_token') final  String refreshToken;
/// Unix timestamp (segundos) en que expira el access_token.
@override@JsonKey(name: 'expires_at') final  int expiresAt;
@override final  UserDto user;
 final  List<CompanyDto> _companies;
@override@JsonKey() List<CompanyDto> get companies {
  if (_companies is EqualUnmodifiableListView) return _companies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_companies);
}

@override@JsonKey(name: 'selected_company_id') final  String? selectedCompanyId;

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseDtoCopyWith<_LoginResponseDto> get copyWith => __$LoginResponseDtoCopyWithImpl<_LoginResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._companies, _companies)&&(identical(other.selectedCompanyId, selectedCompanyId) || other.selectedCompanyId == selectedCompanyId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresAt,user,const DeepCollectionEquality().hash(_companies),selectedCompanyId);

@override
String toString() {
  return 'LoginResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt, user: $user, companies: $companies, selectedCompanyId: $selectedCompanyId)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseDtoCopyWith<$Res> implements $LoginResponseDtoCopyWith<$Res> {
  factory _$LoginResponseDtoCopyWith(_LoginResponseDto value, $Res Function(_LoginResponseDto) _then) = __$LoginResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'access_token') String accessToken,@JsonKey(name: 'refresh_token') String refreshToken,@JsonKey(name: 'expires_at') int expiresAt, UserDto user, List<CompanyDto> companies,@JsonKey(name: 'selected_company_id') String? selectedCompanyId
});


@override $UserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$LoginResponseDtoCopyWithImpl<$Res>
    implements _$LoginResponseDtoCopyWith<$Res> {
  __$LoginResponseDtoCopyWithImpl(this._self, this._then);

  final _LoginResponseDto _self;
  final $Res Function(_LoginResponseDto) _then;

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresAt = null,Object? user = null,Object? companies = null,Object? selectedCompanyId = freezed,}) {
  return _then(_LoginResponseDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserDto,companies: null == companies ? _self._companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyDto>,selectedCompanyId: freezed == selectedCompanyId ? _self.selectedCompanyId : selectedCompanyId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LoginResponseDto
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
