import 'package:flutter/material.dart';
import 'package:teste/pages/product_registration.dart';
import 'package:teste/pages/splash_screen.dart';
import 'package:teste/pages/login.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String productRegistration = '/product_registration';

  static Route<dynamic> generateRoute(RouteSettings settings, void Function(Locale) changeLanguage) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage(changeLanguage: changeLanguage));
      case productRegistration:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final username = args['username'] ?? 'Usuário';
        return MaterialPageRoute(
          builder: (_) => ProductRegistrationPage( username: username, changeLanguage: changeLanguage),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Página não encontrada :('),
            ),
          ),
        );
    }
  }
}