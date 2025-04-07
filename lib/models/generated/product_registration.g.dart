// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductRegistrationDataImpl _$$ProductRegistrationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductRegistrationDataImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      category: json['category_type'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      value: (json['value'] as num).toDouble(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$ProductRegistrationDataImplToJson(
        _$ProductRegistrationDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      if (instance.category case final value?) 'category_type': value,
      if (instance.quantity case final value?) 'quantity': value,
      'value': instance.value,
      if (instance.url case final value?) 'url': value,
    };
