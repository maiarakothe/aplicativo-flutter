import 'package:flutter/material.dart';
import 'package:teste/pages/product_registration.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:teste/core/theme_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductRegistrationPage(
            username: usernameController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem vindo!'),
        centerTitle: true,
        actions: [ThemeToggleButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/mobilelogin.png",
                width: 200,
                height: 200,
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Usuário",
                  border: OutlineInputBorder(
                    borderRadius: Configs.radiusBorder,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu usuário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(
                    borderRadius: Configs.radiusBorder,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DefaultColors.backgroundButton,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: Configs.buttonBorderRadius,
                  ),
                ),
                onPressed: _login,
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 19, color: DefaultColors.textColorButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
