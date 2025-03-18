import 'package:flutter/material.dart';
import 'package:teste/core/themes.dart';
import 'package:teste/core/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:teste/pages/login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDark ? themeDarkData() : themeLightData(),
      home: LoginPage(),
    );
  }
}
