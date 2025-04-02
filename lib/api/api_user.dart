import 'dart:convert';

import '../core/http_utils.dart';
import 'api_base_module.dart';

class UserAPI extends BaseModuleAPI {
  UserAPI(super.api);

  Future<Map<String, dynamic>> getUser() async {
    final response = await requestWrapper(
          () => api.dio.get('/user'),
    );
    return response.data;
  }

  Future<void> updateUser({
    required String name,
    required String newPassword,
    required String oldPassword,
  }) async {
    await requestWrapper(
          () => api.dio.patch(
        '/user/update',
        data: jsonEncode({
          'name': name,
          'new_password': newPassword,
          'old_password': oldPassword,
        }),
      ),
    );
  }
}