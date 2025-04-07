import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:teste/core/http_utils.dart';
import 'package:teste/models/account.dart';

part 'generated/user.freezed.dart';
part 'generated/user.g.dart';

@freezed
class User with _$User {
  factory User({
    required int id,
    required String name,
    required String email,
    required String password,
    required List<PermissionData> permissions,
  }) = _User;

  factory User.fromJson(JSON json) => _$UserFromJson(json);
}
