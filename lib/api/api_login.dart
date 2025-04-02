import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:teste/api/api.dart';
import '../core/http_utils.dart';
import 'api_base_module.dart';
import 'package:teste/pages/login.dart';

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

}
