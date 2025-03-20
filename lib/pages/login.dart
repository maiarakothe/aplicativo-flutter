import 'package:flutter/material.dart';
import 'package:teste/pages/product_registration.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:teste/core/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/utils/validators.dart';

class LoginPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const LoginPage({Key? key, required this.changeLanguage}) : super(key: key);

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
            changeLanguage: widget.changeLanguage,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.welcome),
        centerTitle: true,
        actions: [
          // Botão para mudar o idioma
          DropdownButton<Locale>(
            icon: Icon(Icons.language, color: Colors.white),
            dropdownColor: Colors.black,
            underline: SizedBox.shrink(),
            onChanged: (Locale? newValue) {
              if (newValue != null) {
                widget.changeLanguage(newValue);
              }
            },
            items: [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: Locale('pt'),
                child: Text('Português', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          ThemeToggleButton(),
        ],
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
                  labelText: localizations.username,
                  border: OutlineInputBorder(
                    borderRadius: Configs.radiusBorder,
                  ),
                ),
                validator: (value) => Validators.validateUsername(value, localizations),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: localizations.password,
                  border: OutlineInputBorder(
                    borderRadius: Configs.radiusBorder,
                  ),
                ),
                validator: (value) => Validators.validatePassword(value, localizations),
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
                  localizations.login,
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
