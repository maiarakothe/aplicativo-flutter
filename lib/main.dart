import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:teste/core/themes.dart';
import 'package:teste/providers/theme_provider.dart';
import 'package:teste/core/l10n.dart';
import 'package:teste/providers/user_provider.dart';
import 'package:teste/routes.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UsersProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key
  });

  static final GlobalKey<_MyAppState> appStateKey = GlobalKey<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('pt');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: themeProvider.isDark ? themeDarkData() : themeLightData(),
      initialRoute: Routes.splash,
      onGenerateRoute: (settings) => Routes.generateRoute(settings, _changeLanguage),
    );
  }
}