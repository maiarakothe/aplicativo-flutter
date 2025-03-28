import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/configs.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:teste/core/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/routes.dart';
import 'package:teste/services/auth_service.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';

class LoginPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const LoginPage({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _login(BuildContext context, Map<String, dynamic> data) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      final localizations = AppLocalizations.of(context)!;

      try {
        final email = data['email']?.trim() ?? '';
        final password = data['password']?.trim() ?? '';

        await _authService.login(email, password);

        navigator.pushReplacementNamed(
          Routes.productRegistration,
          arguments: {
            'changeLanguage': widget.changeLanguage,
          },
        );
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text(localizations.loginError)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    AFormDialog.show<Map<String, dynamic>>(
      context,
      title: AppLocalizations.of(context)!.forgotPassword,
      submitText: AppLocalizations.of(context)!.send,
      onSubmit: (data) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.resetLinkSent),
            backgroundColor: DefaultColors.green,
            duration: Duration(seconds: 2),
          ),
        );
      },
      fields: [
        AFieldEmail(
          identifier: 'email',
          label: AppLocalizations.of(context)!.email,
          required: true,
        ),
      ],
      persistent: false,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.welcome),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SingleChildScrollView(
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
                AForm<Map<String, dynamic>>(
                  fromJson: (json) => json as Map<String, dynamic>,
                  showDefaultAction: false,
                  submitText: localizations.login,
                  onSubmit: (data) async {
                    _login(context, data);
                    return null;
                  },
                  fields: [
                    AFieldEmail(
                      identifier: 'email',
                      label: localizations.email,
                      required: true,
                    ),
                    SizedBox(height: 16),
                    AFieldPassword(
                      identifier: 'password',
                      label: localizations.password,
                      minLength: 8,
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog(context);
                        },
                        child: Text(localizations.forgotPassword),
                      ),
                    ),
                    SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        return Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DefaultColors.backgroundButton,
                              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: Configs.buttonBorderRadius,
                              ),
                            ),
                            onPressed: _isLoading
                                ? null
                                : () {
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
                            child: _isLoading
                                ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(DefaultColors.textColorButton),
                            )
                                : Text(
                              localizations.login,
                              style: TextStyle(fontSize: 19, color: DefaultColors.textColorButton),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.register);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: DefaultColors.snackBar,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.noAccount,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}