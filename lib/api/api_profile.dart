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
    String newPassword = '',
    String oldPassword = '',
  }) async {
    await requestWrapper(
          () => api.dio.patch(
        '/user/update',
        data: jsonEncode({
          'name': name,
          'new_password': newPassword.isNotEmpty ? newPassword : null,
          'old_password': oldPassword.isNotEmpty ? oldPassword : null,
        }),
      ),
    );
  }
}