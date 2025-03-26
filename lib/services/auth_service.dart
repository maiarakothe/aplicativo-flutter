import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Método para verificar se o usuário está logado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return token != null;
  }

  // Método de login
  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (email == 'm@gmail.com' && password == '12345678') {
      await prefs.setString('auth_token', 'some_auth_token');
      await prefs.setString('email', email);
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // Método para fazer logout e limpar dados
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('email');
  }
}
