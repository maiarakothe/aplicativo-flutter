import 'package:dio/dio.dart';
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
        },
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['detail'] ?? 'Erro ao criar usuário');
    }
  }
}