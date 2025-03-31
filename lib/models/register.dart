import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/register.freezed.dart';
part 'generated/register.g.dart';

@Freezed()
class RegisterData with _$RegisterData {
  const factory RegisterData({
    required String name,
    required String email,
    required String password,
  }) = _RegisterData;

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);
}
