import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:teste/models/account.dart';

import '../core/http_utils.dart';
import '../models/account_permission.dart';
import '../models/user.dart';
import 'api.dart';

class UserAPI {
  final API _api;
  UserAPI(this._api);

  Future<User> createUser(int accountId, User user) async {
    try {
      final response = await _api.dio.post(
        '/member',
        queryParameters: {'account_id': accountId},
        data: {
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'permissions': user.permissions.map((p) => p.permission.encoded).toList(),
        },
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Erro ao criar usuário');
    }
  }

  Future<User> editMember({
    required int accountId,
    required User user,
  }) async {
    final data = {
      'permissions': user.permissions.map((p) => p.permission.encoded).toList(),
    };

    final response = await requestWrapper(() => _api.dio.put(
      '/member/edit',
      queryParameters: {
        'user_id': user.id,
        'account_id': accountId,
      },
      data: data,
    ));

    return User.fromJson(response.data);
  }

  Future<List<User>> getMembers(int accountId) async {
    final response = await requestWrapper(
          () => _api.dio.get(
        '/members/$accountId',
      ),
    );

    debugPrint('[RAW USERS RESPONSE] ${response.data}');
    final List<Map<String, dynamic>> rawUsers = List<Map<String, dynamic>>.from(response.data);
    return rawUsers.map((json) => User.fromJson(json)).toList();
  }
}