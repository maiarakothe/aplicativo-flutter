import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/product_registration.freezed.dart';
part 'generated/product_registration.g.dart';

@freezed
class ProductRegistrationData with _$ProductRegistrationData {
  const factory ProductRegistrationData({
    required String productName,
    required String url,
    required double price,
  }) = _ProductRegistrationData;

  factory ProductRegistrationData.fromJson(Map<String, dynamic> json) =>
      _$ProductRegistrationDataFromJson(json);
}