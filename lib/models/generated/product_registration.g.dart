// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../product_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductRegistrationDataImpl _$$ProductRegistrationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductRegistrationDataImpl(
      productName: json['product_name'] as String,
      url: json['url'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductRegistrationDataImplToJson(
        _$ProductRegistrationDataImpl instance) =>
    <String, dynamic>{
      'product_name': instance.productName,
      'url': instance.url,
      'price': instance.price,
    };
