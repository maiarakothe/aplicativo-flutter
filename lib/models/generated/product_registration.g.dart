// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductRegistrationDataImpl _$$ProductRegistrationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductRegistrationDataImpl(
      category: json['category'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductRegistrationDataImplToJson(
        _$ProductRegistrationDataImpl instance) =>
    <String, dynamic>{
      if (instance.category case final value?) 'category': value,
      if (instance.quantity case final value?) 'quantity': value,
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'value': instance.value,
    };
