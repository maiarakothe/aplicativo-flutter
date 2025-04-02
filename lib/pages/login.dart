import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
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
import '../models/forgot_password.dart';
import '../models/login.dart';
import 'package:teste/api/api.dart';
import '../api/api_login.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;
  const LoginPage({super.key, required this.changeLanguage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final LoginAPI _loginAPI = LoginAPI(API());

  void _login(LoginData data) async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await _loginAPI.login(
        email: data.email.trim(),
        password: data.password.trim(),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.productRegistration,
            (route) => false,
      );
    } catch (e) {
      String errorMessage = "Erro ao tentar fazer login.";
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage = "Senha incorreta. Tente novamente.";
        } else if (e.response?.statusCode == 404) {
          errorMessage = "E-mail inválido. Verifique e tente novamente.";
        } else if (e.response?.statusCode == 422) {
          errorMessage = "Erro de validação. Verifique os dados inseridos.";
        }
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      print("Erro ao tentar logar: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    AFormDialog.show<ForgotPasswordData>(
      context,
      title: AppLocalizations.of(context)!.forgotPassword,
      submitText: AppLocalizations.of(context)!.send,
      onSubmit: (ForgotPasswordData data) async {
        final messenger = ScaffoldMessenger.of(context);
        final email = data.email.trim();

        try {
          await API.forgotPassword.forgotPassword(email: email);

          messenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.resetLinkSent),
              backgroundColor: DefaultColors.green,
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(Duration(seconds: 1), () {
            _showResetPasswordDialog(context);
          });

        } on DioException catch (e) {
          String errorMessage = "Erro ao solicitar recuperação de senha.";

          if (e.response != null) {
            print("Erro na recuperação de senha: ${e.response?.data}");

            if (e.response?.statusCode == 404) {
              errorMessage = "E-mail inválido.";
            } else if (e.response?.statusCode == 422) {
              errorMessage = "Erro de validação.";
            } else {
              errorMessage = "Erro: ${e.response?.data['message'] ?? 'Ocorreu um erro desconhecido.'}";
            }
          } else {
            print("Erro na recuperação de senha: $e");
            errorMessage = "Erro inesperado. Verifique sua conexão.";
          }

          messenger.showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      fields: [
        AFieldEmail(
          identifier: 'email',
          label: AppLocalizations.of(context)!.email,
          required: true,
        ),
      ],
      persistent: false,
      fromJson: (json) => ForgotPasswordData.fromJson(json),
    );
  }

  void _showResetPasswordDialog(BuildContext context) async {
    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: AppLocalizations.of(context)!.resetPassword,
      submitText: AppLocalizations.of(context)!.confirm,
      onSubmit: (data) async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          await API.forgotPassword.resetPassword(
            code: data['code']!.trim(),
            newPassword: data['new_password']!.trim(),
          );
          messenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordChanged),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.somethingWentWrong),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      fields: [
        AFieldText(
          identifier: 'code',
          label: AppLocalizations.of(context)!.verificationCode,
          required: true,
        ),
        AFieldPassword(
          identifier: 'new_password',
          label: AppLocalizations.of(context)!.newPassword,
        ),
      ],
      persistent: false,
      fromJson: (json) => json as Map<String, String>,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/mobilelogin.png",
                width: 200,
                height: 200,
              ),
              SizedBox(height: 40),
              AForm<LoginData>(
                fromJson: (json) => LoginData.fromJson(json),
                showDefaultAction: false,
                submitText: AppLocalizations.of(context)!.login,
                onSubmit: (LoginData data) async {
                  _login(data);
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
                        child: AButton(
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
                          text: localizations.login,
                          loading: _isLoading,
                          textColor: DefaultColors.textColorButton,
                          fontSize: 19,
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
    );
  }
}