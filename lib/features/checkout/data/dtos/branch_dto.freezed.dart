// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchDto {

 String get id;@JsonKey(name: 'codigo') String get code;@JsonKey(name: 'nombre') String get name;@JsonKey(name: 'direccion') String? get address;@JsonKey(name: 'ciudad') String? get city;@JsonKey(name: 'telefono') String? get phone;@JsonKey(name: 'id_lista_precios') String? get priceListId;@JsonKey(name: 'es_principal') bool get isDefault;
/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchDtoCopyWith<BranchDto> get copyWith => _$BranchDtoCopyWithImpl<BranchDto>(this as BranchDto, _$identity);

  /// Serializes this BranchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchDto&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.priceListId, priceListId) || other.priceListId == priceListId)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,address,city,phone,priceListId,isDefault);

@override
String toString() {
  return 'BranchDto(id: $id, code: $code, name: $name, address: $address, city: $city, phone: $phone, priceListId: $priceListId, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class $BranchDtoCopyWith<$Res>  {
  factory $BranchDtoCopyWith(BranchDto value, $Res Function(BranchDto) _then) = _$BranchDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'codigo') String code,@JsonKey(name: 'nombre') String name,@JsonKey(name: 'direccion') String? address,@JsonKey(name: 'ciudad') String? city,@JsonKey(name: 'telefono') String? phone,@JsonKey(name: 'id_lista_precios') String? priceListId,@JsonKey(name: 'es_principal') bool isDefault
});




}
/// @nodoc
class _$BranchDtoCopyWithImpl<$Res>
    implements $BranchDtoCopyWith<$Res> {
  _$BranchDtoCopyWithImpl(this._self, this._then);

  final BranchDto _self;
  final $Res Function(BranchDto) _then;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = freezed,Object? city = freezed,Object? phone = freezed,Object? priceListId = freezed,Object? isDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,priceListId: freezed == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchDto].
extension BranchDtoPatterns on BranchDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchDto value)  $default,){
final _that = this;
switch (_that) {
case _BranchDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchDto value)?  $default,){
final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'codigo')  String code, @JsonKey(name: 'nombre')  String name, @JsonKey(name: 'direccion')  String? address, @JsonKey(name: 'ciudad')  String? city, @JsonKey(name: 'telefono')  String? phone, @JsonKey(name: 'id_lista_precios')  String? priceListId, @JsonKey(name: 'es_principal')  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.city,_that.phone,_that.priceListId,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'codigo')  String code, @JsonKey(name: 'nombre')  String name, @JsonKey(name: 'direccion')  String? address, @JsonKey(name: 'ciudad')  String? city, @JsonKey(name: 'telefono')  String? phone, @JsonKey(name: 'id_lista_precios')  String? priceListId, @JsonKey(name: 'es_principal')  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _BranchDto():
return $default(_that.id,_that.code,_that.name,_that.address,_that.city,_that.phone,_that.priceListId,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'codigo')  String code, @JsonKey(name: 'nombre')  String name, @JsonKey(name: 'direccion')  String? address, @JsonKey(name: 'ciudad')  String? city, @JsonKey(name: 'telefono')  String? phone, @JsonKey(name: 'id_lista_precios')  String? priceListId, @JsonKey(name: 'es_principal')  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _BranchDto() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.address,_that.city,_that.phone,_that.priceListId,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchDto implements BranchDto {
  const _BranchDto({required this.id, @JsonKey(name: 'codigo') required this.code, @JsonKey(name: 'nombre') required this.name, @JsonKey(name: 'direccion') this.address, @JsonKey(name: 'ciudad') this.city, @JsonKey(name: 'telefono') this.phone, @JsonKey(name: 'id_lista_precios') this.priceListId, @JsonKey(name: 'es_principal') this.isDefault = false});
  factory _BranchDto.fromJson(Map<String, dynamic> json) => _$BranchDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'codigo') final  String code;
@override@JsonKey(name: 'nombre') final  String name;
@override@JsonKey(name: 'direccion') final  String? address;
@override@JsonKey(name: 'ciudad') final  String? city;
@override@JsonKey(name: 'telefono') final  String? phone;
@override@JsonKey(name: 'id_lista_precios') final  String? priceListId;
@override@JsonKey(name: 'es_principal') final  bool isDefault;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchDtoCopyWith<_BranchDto> get copyWith => __$BranchDtoCopyWithImpl<_BranchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchDto&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.priceListId, priceListId) || other.priceListId == priceListId)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,address,city,phone,priceListId,isDefault);

@override
String toString() {
  return 'BranchDto(id: $id, code: $code, name: $name, address: $address, city: $city, phone: $phone, priceListId: $priceListId, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$BranchDtoCopyWith<$Res> implements $BranchDtoCopyWith<$Res> {
  factory _$BranchDtoCopyWith(_BranchDto value, $Res Function(_BranchDto) _then) = __$BranchDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'codigo') String code,@JsonKey(name: 'nombre') String name,@JsonKey(name: 'direccion') String? address,@JsonKey(name: 'ciudad') String? city,@JsonKey(name: 'telefono') String? phone,@JsonKey(name: 'id_lista_precios') String? priceListId,@JsonKey(name: 'es_principal') bool isDefault
});




}
/// @nodoc
class __$BranchDtoCopyWithImpl<$Res>
    implements _$BranchDtoCopyWith<$Res> {
  __$BranchDtoCopyWithImpl(this._self, this._then);

  final _BranchDto _self;
  final $Res Function(_BranchDto) _then;

/// Create a copy of BranchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? address = freezed,Object? city = freezed,Object? phone = freezed,Object? priceListId = freezed,Object? isDefault = null,}) {
  return _then(_BranchDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,priceListId: freezed == priceListId ? _self.priceListId : priceListId // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
