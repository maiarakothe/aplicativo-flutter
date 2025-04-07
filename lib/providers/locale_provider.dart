import 'package:flutter/material.dart';
import 'package:teste/core/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('pt');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}
