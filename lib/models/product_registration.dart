import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/product_registration.freezed.dart';
part 'generated/product_registration.g.dart';

@freezed
class ProductRegistrationData with _$ProductRegistrationData {
  const factory ProductRegistrationData({
    String? category,
    int? quantity,
    required String id,
    required String name,
    required String url,
    required double value,
  }) = _ProductRegistrationData;

  factory ProductRegistrationData.fromJson(Map<String, dynamic> json) =>
      _$ProductRegistrationDataFromJson(json);

}