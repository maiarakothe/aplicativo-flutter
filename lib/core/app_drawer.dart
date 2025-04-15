import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api.dart';
import '../api/api_login.dart';
import '../configs.dart' as widget;
import '../routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    bool confirmLogout = await _showLogoutDialog(context);
    if (confirmLogout) {
      try {
        final loginAPI = LoginAPI(API());
        await loginAPI.logout();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      } catch (e) {
        debugPrint('Erro ao deslogar: $e');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao sair"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    final local = AppLocalizations.of(context);
    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(local.confirmLogout),
            content: Text(local.areYouSureLogout),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(local.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  local.logout,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return Drawer(
      child: Container(
        width: 250,
        color: Theme
            .of(context)
            .drawerTheme
            .backgroundColor ??
            Theme
                .of(context)
                .scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.business, size: 64),
                  const SizedBox(height: 8),
                  Text(
                    widget.selectedAccount?.name ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(local.profile),
              onTap: () => Navigator.pushNamed(context, Routes.profilePage),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: Text(local.registerProduct),
              onTap: () => Navigator.pushNamed(context, Routes.productRegistration),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: Text(local.productList),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.productList,
                      (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(local.users),
              onTap: () {
                Navigator.pushNamed(context, Routes.userPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_open),
              title: Text(local.importFile),
              onTap: () {
                Navigator.pushNamed(context, Routes.filePage);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(local.logout),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}