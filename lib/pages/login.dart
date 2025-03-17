import 'package:flutter/material.dart';
import 'package:teste/pages/product_registration.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';

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
      print("Login bem-sucedido!");
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
    return Scaffold(
      backgroundColor: DefaultColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: DefaultColors.circleAvatar,
                child: Icon(Icons.person, size: 120, color: DefaultColors.iconPerson),
              ),
              SizedBox(height: 40),

              // Campo de Usuário
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

              // Campo de Senha
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

              // Botão de Login
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
                  style: TextStyle(fontSize: 19, color: DefaultColors.textColorButton ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
