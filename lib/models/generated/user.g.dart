// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['user_id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => PermissionData.fromJson(e as Map<String, dynamic>))
          .toList(),
      owner: json['owner'] as bool? ?? false,
      isActive: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      if (instance.password case final value?) 'password': value,
      'permissions': instance.permissions.map((e) => e.toJson()).toList(),
      'owner': instance.owner,
      'active': instance.isActive,
    };
