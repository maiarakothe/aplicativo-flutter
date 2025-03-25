import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static String? validateUsername(
      String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.enterUsername;
    }
    return null;
  }

  static String? validatePassword(
      String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.enterPassword;
    }
    if (value.length < 6) {
      return localizations.passwordTooShort;
    }
    return null;
  }

  static String? validateProductName(
      String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.insertProductName;
    }
    return null;
  }

  static String? validateProductPrice(
      String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.insertProductPrice;
    }
    if (value.replaceAll('R\$ ', '') == '0,00') {
      return localizations.requiredField;
    }
    return null;
  }

  static String? validateProductImageURL(
      String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.insertProductImageURL;
    }
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return localizations.urlMustStartWithHTTP;
    }
    return null;
  }

  static String? validateEmail(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.enterEmail;
    }

    // Expressão regular para validar o formato de e-mail
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(value)) {
      return localizations.invalidEmail;
    }
    return null;
  }

}
