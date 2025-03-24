import 'package:flutter/material.dart';
import 'package:teste/routes.dart';
import 'package:teste/core/colors.dart';

class SplashScreen extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const SplashScreen({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
        context,
        Routes.login,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_mall_outlined,
              size: 120,
              color: DefaultColors.backgroundButton,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(DefaultColors.backgroundButton),
            ),
          ],
        ),
      ),
    );
  }
}
