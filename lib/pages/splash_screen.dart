import 'package:flutter/material.dart';
import 'package:teste/routes.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/api/api.dart';
import '../configs.dart';
import '../models/account.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));
    bool isLoggedInAndStayConnected = await AuthService.isUserLoggedInAndStayConnected();
    bool isLoggedIn = await AuthService.isLoggedIn();

    if (mounted) {
      if (isLoggedInAndStayConnected || isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        final savedAccountId = prefs.getInt('selected_account_id');

        if (savedAccountId != null) {
          try {
            final account = await API.accounts.getCurrentAccount(savedAccountId);
            selectedAccount = Account.fromJson(account);
          } catch (e) {
            print("Erro ao carregar conta salva: $e");
            selectedAccount = null;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context).error),
                  content: Text(AppLocalizations.of(context).failedToLoadSavedAccount),
                  actions: <Widget>[
                    TextButton(
                      child: Text(AppLocalizations.of(context).ok),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.login);
                      },
                    ),
                  ],
                );
              },
            );
            return;
          }
        }

        if (selectedAccount?.id != null) {
          Navigator.pushReplacementNamed(context, Routes.productList);
        } else {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
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