import 'dart:convert';
import '../core/http_utils.dart';
import 'api_base_module.dart';

class ForgotPasswordAPI extends BaseModuleAPI {
  ForgotPasswordAPI(super.api);

  Future<void> forgotPassword({
    required String email,
  }) async {
    await requestWrapper(
          () =>
          api.dio.put(
            '/forgot-password',
            queryParameters: {'email': email},
          ),
    );
  }

  Future<void> resetPassword({
    required String code,
    required String newPassword,
  }) async {
      await requestWrapper(
            () =>
            api.dio.put(
              '/password_recovery/set_password',
              data: jsonEncode({
                'code': code,
                'new_password': newPassword,
              }),
            ),
      );
  }
}
