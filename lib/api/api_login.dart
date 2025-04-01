import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/http_utils.dart';
import 'api_base_module.dart';

class LoginAPI extends BaseModuleAPI {
  LoginAPI(super.api);

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.dio.post(
        '/login',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Verifica se a resposta contém o token
      if (response.statusCode == 200) {
        final responseData = response.data;
        final token = responseData['access_token'];

        if (token == null) {
          throw Exception("Token não recebido");
        }
        return token;
      } else {
        throw Exception("Erro no login: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao tentar logar: $e");
      throw Exception("Falha na autenticação");
    }
  }
}
