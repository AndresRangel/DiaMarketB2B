// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState()';
}


}

/// @nodoc
class $OtpStateCopyWith<$Res>  {
$OtpStateCopyWith(OtpState _, $Res Function(OtpState) __);
}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OtpStateInitial value)?  initial,TResult Function( OtpStateSendingOtp value)?  sendingOtp,TResult Function( OtpStateOtpSent value)?  otpSent,TResult Function( OtpStateValidating value)?  validating,TResult Function( OtpStateSuccess value)?  success,TResult Function( OtpStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OtpStateInitial() when initial != null:
return initial(_that);case OtpStateSendingOtp() when sendingOtp != null:
return sendingOtp(_that);case OtpStateOtpSent() when otpSent != null:
return otpSent(_that);case OtpStateValidating() when validating != null:
return validating(_that);case OtpStateSuccess() when success != null:
return success(_that);case OtpStateError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OtpStateInitial value)  initial,required TResult Function( OtpStateSendingOtp value)  sendingOtp,required TResult Function( OtpStateOtpSent value)  otpSent,required TResult Function( OtpStateValidating value)  validating,required TResult Function( OtpStateSuccess value)  success,required TResult Function( OtpStateError value)  error,}){
final _that = this;
switch (_that) {
case OtpStateInitial():
return initial(_that);case OtpStateSendingOtp():
return sendingOtp(_that);case OtpStateOtpSent():
return otpSent(_that);case OtpStateValidating():
return validating(_that);case OtpStateSuccess():
return success(_that);case OtpStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OtpStateInitial value)?  initial,TResult? Function( OtpStateSendingOtp value)?  sendingOtp,TResult? Function( OtpStateOtpSent value)?  otpSent,TResult? Function( OtpStateValidating value)?  validating,TResult? Function( OtpStateSuccess value)?  success,TResult? Function( OtpStateError value)?  error,}){
final _that = this;
switch (_that) {
case OtpStateInitial() when initial != null:
return initial(_that);case OtpStateSendingOtp() when sendingOtp != null:
return sendingOtp(_that);case OtpStateOtpSent() when otpSent != null:
return otpSent(_that);case OtpStateValidating() when validating != null:
return validating(_that);case OtpStateSuccess() when success != null:
return success(_that);case OtpStateError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  sendingOtp,TResult Function( String phone,  int resendCooldown)?  otpSent,TResult Function()?  validating,TResult Function()?  success,TResult Function( String message,  String? previousPhone)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OtpStateInitial() when initial != null:
return initial();case OtpStateSendingOtp() when sendingOtp != null:
return sendingOtp();case OtpStateOtpSent() when otpSent != null:
return otpSent(_that.phone,_that.resendCooldown);case OtpStateValidating() when validating != null:
return validating();case OtpStateSuccess() when success != null:
return success();case OtpStateError() when error != null:
return error(_that.message,_that.previousPhone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  sendingOtp,required TResult Function( String phone,  int resendCooldown)  otpSent,required TResult Function()  validating,required TResult Function()  success,required TResult Function( String message,  String? previousPhone)  error,}) {final _that = this;
switch (_that) {
case OtpStateInitial():
return initial();case OtpStateSendingOtp():
return sendingOtp();case OtpStateOtpSent():
return otpSent(_that.phone,_that.resendCooldown);case OtpStateValidating():
return validating();case OtpStateSuccess():
return success();case OtpStateError():
return error(_that.message,_that.previousPhone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  sendingOtp,TResult? Function( String phone,  int resendCooldown)?  otpSent,TResult? Function()?  validating,TResult? Function()?  success,TResult? Function( String message,  String? previousPhone)?  error,}) {final _that = this;
switch (_that) {
case OtpStateInitial() when initial != null:
return initial();case OtpStateSendingOtp() when sendingOtp != null:
return sendingOtp();case OtpStateOtpSent() when otpSent != null:
return otpSent(_that.phone,_that.resendCooldown);case OtpStateValidating() when validating != null:
return validating();case OtpStateSuccess() when success != null:
return success();case OtpStateError() when error != null:
return error(_that.message,_that.previousPhone);case _:
  return null;

}
}

}

/// @nodoc


class OtpStateInitial implements OtpState {
  const OtpStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.initial()';
}


}




/// @nodoc


class OtpStateSendingOtp implements OtpState {
  const OtpStateSendingOtp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpStateSendingOtp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.sendingOtp()';
}


}




/// @nodoc


class OtpStateOtpSent implements OtpState {
  const OtpStateOtpSent({required this.phone, this.resendCooldown = 60});
  

 final  String phone;
@JsonKey() final  int resendCooldown;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateOtpSentCopyWith<OtpStateOtpSent> get copyWith => _$OtpStateOtpSentCopyWithImpl<OtpStateOtpSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpStateOtpSent&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.resendCooldown, resendCooldown) || other.resendCooldown == resendCooldown));
}


@override
int get hashCode => Object.hash(runtimeType,phone,resendCooldown);

@override
String toString() {
  return 'OtpState.otpSent(phone: $phone, resendCooldown: $resendCooldown)';
}


}

/// @nodoc
abstract mixin class $OtpStateOtpSentCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory $OtpStateOtpSentCopyWith(OtpStateOtpSent value, $Res Function(OtpStateOtpSent) _then) = _$OtpStateOtpSentCopyWithImpl;
@useResult
$Res call({
 String phone, int resendCooldown
});




}
/// @nodoc
class _$OtpStateOtpSentCopyWithImpl<$Res>
    implements $OtpStateOtpSentCopyWith<$Res> {
  _$OtpStateOtpSentCopyWithImpl(this._self, this._then);

  final OtpStateOtpSent _self;
  final $Res Function(OtpStateOtpSent) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? resendCooldown = null,}) {
  return _then(OtpStateOtpSent(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,resendCooldown: null == resendCooldown ? _self.resendCooldown : resendCooldown // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class OtpStateValidating implements OtpState {
  const OtpStateValidating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpStateValidating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.validating()';
}


}




/// @nodoc


class OtpStateSuccess implements OtpState {
  const OtpStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.success()';
}


}




/// @nodoc


class OtpStateError implements OtpState {
  const OtpStateError({required this.message, this.previousPhone});
  

 final  String message;
 final  String? previousPhone;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateErrorCopyWith<OtpStateError> get copyWith => _$OtpStateErrorCopyWithImpl<OtpStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpStateError&&(identical(other.message, message) || other.message == message)&&(identical(other.previousPhone, previousPhone) || other.previousPhone == previousPhone));
}


@override
int get hashCode => Object.hash(runtimeType,message,previousPhone);

@override
String toString() {
  return 'OtpState.error(message: $message, previousPhone: $previousPhone)';
}


}

/// @nodoc
abstract mixin class $OtpStateErrorCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory $OtpStateErrorCopyWith(OtpStateError value, $Res Function(OtpStateError) _then) = _$OtpStateErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? previousPhone
});




}
/// @nodoc
class _$OtpStateErrorCopyWithImpl<$Res>
    implements $OtpStateErrorCopyWith<$Res> {
  _$OtpStateErrorCopyWithImpl(this._self, this._then);

  final OtpStateError _self;
  final $Res Function(OtpStateError) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousPhone = freezed,}) {
  return _then(OtpStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousPhone: freezed == previousPhone ? _self.previousPhone : previousPhone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
