// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  role: json['role'] as String?,
  fullName: json['full_name'] as String?,
  isApproved: json['is_approved'] as bool? ?? true,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'full_name': instance.fullName,
  'is_approved': instance.isApproved,
};
