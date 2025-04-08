import 'package:flutter/material.dart';
import 'package:teste/pages/product_list.dart';
import 'package:teste/pages/product_registration.dart';
import 'package:teste/pages/profile_page.dart';
import 'package:teste/pages/splash_screen.dart';
import 'package:teste/pages/login.dart';
import 'package:teste/pages/register.dart';
import 'package:teste/pages/users_page.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String productRegistration = '/product_registration';
  static const String productList = '/product_list';
  static const String profilePage = '/profile_page';
  static const String userPage = '/users';

  static Route<dynamic> generateRoute(RouteSettings settings, void Function(Locale) changeLanguage) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage(changeLanguage: changeLanguage));
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage(changeLanguage: changeLanguage));
      case productRegistration:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as int?;
        return MaterialPageRoute(
          builder: (_) => ProductRegistrationPage(changeLanguage: changeLanguage, productId: productId),
        );
      case productList:
        return MaterialPageRoute(
            builder: (_) => ShowProductPage(changeLanguage: changeLanguage));
      case profilePage:
        return MaterialPageRoute(builder: (_) => ProfilePage(changeLanguage: changeLanguage));
      case userPage:
        return MaterialPageRoute(builder: (_) => UsersPage(changeLanguage: changeLanguage));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
              body: Center(child: Text('Página não encontrada :('),
              ),
          ),
        );
    }
  }
}
