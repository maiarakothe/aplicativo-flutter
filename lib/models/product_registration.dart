import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/product_registration.freezed.dart';
part 'generated/product_registration.g.dart';

@freezed
class ProductRegistrationData with _$ProductRegistrationData {
  const factory ProductRegistrationData({
    required int id,
    required String name,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'category_type') String? category,
    int? quantity,
    required double value,
    String? url,
  }) = _ProductRegistrationData;

  factory ProductRegistrationData.fromJson(Map<String, dynamic> json) =>
      _$ProductRegistrationDataFromJson(json);

}