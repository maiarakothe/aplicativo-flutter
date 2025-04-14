import 'dart:convert';
import '../core/http_utils.dart';
import 'api_base_module.dart';

class RegisterAPI extends BaseModuleAPI {
  RegisterAPI(super.api);

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await requestWrapper(
          () => api.dio.post(
        '/signup',
        data: jsonEncode(<String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
        }),),);}

}
