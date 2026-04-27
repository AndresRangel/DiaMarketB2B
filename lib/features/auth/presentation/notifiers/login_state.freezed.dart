// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState()';
}


}

/// @nodoc
class $LoginStateCopyWith<$Res>  {
$LoginStateCopyWith(LoginState _, $Res Function(LoginState) __);
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginStateInitial value)?  initial,TResult Function( LoginStateLoading value)?  loading,TResult Function( LoginStateSuccess value)?  success,TResult Function( LoginStateNeedsCompanySelection value)?  needsCompanySelection,TResult Function( LoginStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial(_that);case LoginStateLoading() when loading != null:
return loading(_that);case LoginStateSuccess() when success != null:
return success(_that);case LoginStateNeedsCompanySelection() when needsCompanySelection != null:
return needsCompanySelection(_that);case LoginStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginStateInitial value)  initial,required TResult Function( LoginStateLoading value)  loading,required TResult Function( LoginStateSuccess value)  success,required TResult Function( LoginStateNeedsCompanySelection value)  needsCompanySelection,required TResult Function( LoginStateError value)  error,}){
final _that = this;
switch (_that) {
case LoginStateInitial():
return initial(_that);case LoginStateLoading():
return loading(_that);case LoginStateSuccess():
return success(_that);case LoginStateNeedsCompanySelection():
return needsCompanySelection(_that);case LoginStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginStateInitial value)?  initial,TResult? Function( LoginStateLoading value)?  loading,TResult? Function( LoginStateSuccess value)?  success,TResult? Function( LoginStateNeedsCompanySelection value)?  needsCompanySelection,TResult? Function( LoginStateError value)?  error,}){
final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial(_that);case LoginStateLoading() when loading != null:
return loading(_that);case LoginStateSuccess() when success != null:
return success(_that);case LoginStateNeedsCompanySelection() when needsCompanySelection != null:
return needsCompanySelection(_that);case LoginStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( AuthSessionEntity session)?  success,TResult Function( AuthSessionEntity session,  List<CompanyEntity> companies)?  needsCompanySelection,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial();case LoginStateLoading() when loading != null:
return loading();case LoginStateSuccess() when success != null:
return success(_that.session);case LoginStateNeedsCompanySelection() when needsCompanySelection != null:
return needsCompanySelection(_that.session,_that.companies);case LoginStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( AuthSessionEntity session)  success,required TResult Function( AuthSessionEntity session,  List<CompanyEntity> companies)  needsCompanySelection,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LoginStateInitial():
return initial();case LoginStateLoading():
return loading();case LoginStateSuccess():
return success(_that.session);case LoginStateNeedsCompanySelection():
return needsCompanySelection(_that.session,_that.companies);case LoginStateError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( AuthSessionEntity session)?  success,TResult? Function( AuthSessionEntity session,  List<CompanyEntity> companies)?  needsCompanySelection,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial();case LoginStateLoading() when loading != null:
return loading();case LoginStateSuccess() when success != null:
return success(_that.session);case LoginStateNeedsCompanySelection() when needsCompanySelection != null:
return needsCompanySelection(_that.session,_that.companies);case LoginStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LoginStateInitial implements LoginState {
  const LoginStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.initial()';
}


}




/// @nodoc


class LoginStateLoading implements LoginState {
  const LoginStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.loading()';
}


}




/// @nodoc


class LoginStateSuccess implements LoginState {
  const LoginStateSuccess(this.session);
  

 final  AuthSessionEntity session;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateSuccessCopyWith<LoginStateSuccess> get copyWith => _$LoginStateSuccessCopyWithImpl<LoginStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateSuccess&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'LoginState.success(session: $session)';
}


}

/// @nodoc
abstract mixin class $LoginStateSuccessCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $LoginStateSuccessCopyWith(LoginStateSuccess value, $Res Function(LoginStateSuccess) _then) = _$LoginStateSuccessCopyWithImpl;
@useResult
$Res call({
 AuthSessionEntity session
});


$AuthSessionEntityCopyWith<$Res> get session;

}
/// @nodoc
class _$LoginStateSuccessCopyWithImpl<$Res>
    implements $LoginStateSuccessCopyWith<$Res> {
  _$LoginStateSuccessCopyWithImpl(this._self, this._then);

  final LoginStateSuccess _self;
  final $Res Function(LoginStateSuccess) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(LoginStateSuccess(
null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSessionEntity,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthSessionEntityCopyWith<$Res> get session {
  
  return $AuthSessionEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc


class LoginStateNeedsCompanySelection implements LoginState {
  const LoginStateNeedsCompanySelection({required this.session, required final  List<CompanyEntity> companies}): _companies = companies;
  

 final  AuthSessionEntity session;
 final  List<CompanyEntity> _companies;
 List<CompanyEntity> get companies {
  if (_companies is EqualUnmodifiableListView) return _companies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_companies);
}


/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateNeedsCompanySelectionCopyWith<LoginStateNeedsCompanySelection> get copyWith => _$LoginStateNeedsCompanySelectionCopyWithImpl<LoginStateNeedsCompanySelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateNeedsCompanySelection&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._companies, _companies));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_companies));

@override
String toString() {
  return 'LoginState.needsCompanySelection(session: $session, companies: $companies)';
}


}

/// @nodoc
abstract mixin class $LoginStateNeedsCompanySelectionCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $LoginStateNeedsCompanySelectionCopyWith(LoginStateNeedsCompanySelection value, $Res Function(LoginStateNeedsCompanySelection) _then) = _$LoginStateNeedsCompanySelectionCopyWithImpl;
@useResult
$Res call({
 AuthSessionEntity session, List<CompanyEntity> companies
});


$AuthSessionEntityCopyWith<$Res> get session;

}
/// @nodoc
class _$LoginStateNeedsCompanySelectionCopyWithImpl<$Res>
    implements $LoginStateNeedsCompanySelectionCopyWith<$Res> {
  _$LoginStateNeedsCompanySelectionCopyWithImpl(this._self, this._then);

  final LoginStateNeedsCompanySelection _self;
  final $Res Function(LoginStateNeedsCompanySelection) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,Object? companies = null,}) {
  return _then(LoginStateNeedsCompanySelection(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSessionEntity,companies: null == companies ? _self._companies : companies // ignore: cast_nullable_to_non_nullable
as List<CompanyEntity>,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthSessionEntityCopyWith<$Res> get session {
  
  return $AuthSessionEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc


class LoginStateError implements LoginState {
  const LoginStateError(this.message);
  

 final  String message;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateErrorCopyWith<LoginStateError> get copyWith => _$LoginStateErrorCopyWithImpl<LoginStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LoginState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $LoginStateErrorCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $LoginStateErrorCopyWith(LoginStateError value, $Res Function(LoginStateError) _then) = _$LoginStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LoginStateErrorCopyWithImpl<$Res>
    implements $LoginStateErrorCopyWith<$Res> {
  _$LoginStateErrorCopyWithImpl(this._self, this._then);

  final LoginStateError _self;
  final $Res Function(LoginStateError) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LoginStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
