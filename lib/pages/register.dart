import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_name.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:flutter/material.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:teste/core/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/routes.dart';

class RegisterPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const RegisterPage({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  void _register(Map<String, dynamic> data) {
    final name = data['name']?.trim() ?? '';
    final email = data['email']?.trim() ?? '';
    final password = data['password']?.trim() ?? '';

    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.productRegistration,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.titleRegister),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
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
      body: Center(
        child: Container(
          child: AForm<Map<String, dynamic>>(
            fromJson: (json) => json as Map<String, dynamic>,
            showDefaultAction: false,
            submitText: localizations.register,
            onSubmit: (data) async {
              _register(data);
              return null;
            },
            fields: [
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFFDFD5C3),
                  child: Icon(Icons.person, size: 120, color: Color(0xFF5D4037)),
                ),
              ),
              const SizedBox(height: 40),
              AFieldName(
                identifier: 'name',
                label: localizations.name,
                required: true,
              ),
              const SizedBox(height: 10),
              AFieldEmail(
                identifier: 'email',
                required: true,
                label: localizations.email,
              ),
              const SizedBox(height: 10),
              AFieldPassword(
                identifier: 'password',
                label: localizations.password,
                minLength: 6,
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (context) {
                  return Center(
                    child: AButton(
                      onPressed: () {
                        final formState = AForm.maybeOf(context);
                        if (formState == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations.formNotFound),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          formState.onSubmit();
                        }
                      },
                      text: localizations.register,
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: DefaultColors.textColorButton,
                      ),
                    ),
                  );
                },
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: DefaultColors.snackBar,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.alreadyHaveAccount,
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.doLogin,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
