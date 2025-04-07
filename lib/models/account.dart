// lib/models/account.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:teste/core/http_utils.dart';
import 'package:teste/models/account_permission.dart';

part 'generated/account.freezed.dart';
part 'generated/account.g.dart';

@Freezed()
class PermissionData with _$PermissionData {
  const factory PermissionData({
    required AccountPermission permission,
    required String ptBr,
  }) = _PermissionData;

  factory PermissionData.fromJson(JSON json) => _$PermissionDataFromJson(json);
}

extension PermissionDataListExtension on List<PermissionData> {
  List<AccountPermission> get asEnums =>
      map((PermissionData p) => p.permission).toList();

  List<String> toJson() {
    return asEnums.toJson();
  }
}

@freezed
class Account with _$Account {
  const Account._();

  const factory Account({
    required int id,
    required String name,
    required List<PermissionData> permissions,
  }) = _Account;

  factory Account.fromJson(JSON json) => _$AccountFromJson(json);

  Set<AccountPermission> get permissionsSet =>
      (permissions.map((PermissionData p) => p.permission).toSet());

  bool havePermission(AccountPermission permission) {
    return permissionsSet.contains(permission);
  }
}
