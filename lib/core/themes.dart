import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData themeLightData() {
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: DefaultColors.backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: DefaultColors.backgroundButton),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DefaultColors.backgroundColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );
}

ThemeData themeDarkData() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DefaultColors.darkBackground,
    appBarTheme: AppBarTheme(backgroundColor: DefaultColors.darkAppBar),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DefaultColors.darkAppBar,
    ),
    cardColor: DefaultColors.darkCard,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: DefaultColors.darkText),
    ),
  );
}
