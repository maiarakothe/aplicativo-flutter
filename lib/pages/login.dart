import 'package:awidgets/fields/a_field_text.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/api/api_account.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/theme_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:teste/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/routes.dart';
import 'package:awidgets/general/a_form.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_password.dart';
import '../configs.dart';
import '../models/forgot_password.dart';
import '../models/login.dart';
import 'package:teste/api/api.dart';
import '../api/api_login.dart';
import 'package:dio/dio.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const LoginPage({super.key, required this.changeLanguage});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _stayConnected = false;

  final LoginAPI _loginAPI = LoginAPI(API());
  final AccountAPI _accountAPI = AccountAPI(API());

  void _login(LoginData data) async {
    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await API.login.login(
        email: data.email.trim(),
        password: data.password.trim(),
      );
      await AuthService.saveLoginToken(data.email);
      await AuthService.setStayConnected(_stayConnected);
      final account = await API.accounts.getAccounts();

      if (selectedAccount?.id != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('selected_account_id', selectedAccount!.id);
      }

      navigator.pushNamedAndRemoveUntil(
          Routes.productList, (route) => false);

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
      title: AppLocalizations.of(context).forgotPassword,
      submitText: AppLocalizations.of(context).send,
      onSubmit: (ForgotPasswordData data) async {
        final messenger = ScaffoldMessenger.of(context);
        final email = data.email.trim();

        try {
          await API.forgotPassword.forgotPassword(email: email);
          messenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).resetLinkSent),
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
              errorMessage =
                  "Erro: ${e.response?.data['message'] ?? 'Ocorreu um erro desconhecido.'}";
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
        return null;
      },
      fields: [
        AFieldEmail(
          identifier: 'email',
          label: AppLocalizations.of(context).email,
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
      title: AppLocalizations.of(context).resetPassword,
      submitText: AppLocalizations.of(context).confirm,
      onSubmit: (data) async {
        final messenger = ScaffoldMessenger.of(context);
        try {
          await API.forgotPassword.resetPassword(
            code: data['code']!.trim(),
            newPassword: data['new_password']!.trim(),
          );
          messenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).passwordChanged),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).somethingWentWrong),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      },
      fields: [
        AFieldText(
          identifier: 'code',
          label: AppLocalizations.of(context).verificationCode,
          required: true,
        ),
        AFieldPassword(
          identifier: 'new_password',
          label: AppLocalizations.of(context).newPassword,
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
        title: Text(localizations.welcome),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ThemeToggleButton(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Image.asset(
                "assets/mobilelogin.png",
                width: 200,
                height: 200,
              ),
              SizedBox(height: 5),
              AForm<LoginData>(
                fromJson: (json) => LoginData.fromJson(json),
                showDefaultAction: false,
                submitText: AppLocalizations.of(context).login,
                onSubmit: (LoginData data) async {
                  _login(data);
                  return null;
                },
                fields: [
                  AFieldEmail(
                    identifier: 'email',
                    label: localizations.email,
                    required: true,
                  ),
                  SizedBox(height: 10),
                  AFieldPassword(
                    identifier: 'password',
                    label: localizations.password,
                    minLength: 8,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _stayConnected,
                        onChanged: (value) {
                          setState(() => _stayConnected = value ?? false);
                        },
                      ),
                      Text(AppLocalizations.of(context).stayConnected,),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog(context);
                        },
                        child: Text(localizations.forgotPassword),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
                                  content:
                                    Text(localizations.formNotFound),
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
                  SizedBox(height: 10),
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
                              text: AppLocalizations.of(context).noAccount,
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context).signUp,
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
