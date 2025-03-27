import 'package:flutter/material.dart';
import 'package:teste/pages/product_registration.dart';
import 'package:teste/pages/splash_screen.dart';
import 'package:teste/pages/login.dart';
import 'package:teste/pages/register.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String productRegistration = '/product_registration';

  static Route<dynamic> generateRoute(RouteSettings settings, void Function(Locale) changeLanguage) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage(changeLanguage: changeLanguage));
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage(changeLanguage: changeLanguage));
      case productRegistration:
        return MaterialPageRoute(
          builder: (_) => ProductRegistrationPage(changeLanguage: changeLanguage, username: '',),
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
