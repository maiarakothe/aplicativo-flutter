import 'dart:convert';
import '../core/http_utils.dart';
import 'api_base_module.dart';

class LoginAPI extends BaseModuleAPI {
  LoginAPI(super.api);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await requestWrapper(
          () => api.dio.post(
        '/login',
        data: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
        }),),);}

  Future<void> logout() async {
    await requestWrapper(
          () => api.dio.get('/logout'),
    );
  }
}
