import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Positioned(
      top: 20,
      right: 20,
      child: IconButton(
        icon: Icon(themeProvider.isDark ? Icons.dark_mode : Icons.light_mode),
        color: Colors.white,
        onPressed: () {
          themeProvider.toggleTheme();
        },
      ),
    );
  }
}
