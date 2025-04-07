import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      width: 250,
      color: Theme.of(context).drawerTheme.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.account_circle, size: 64),
                const SizedBox(height: 8),
                Text(local.welcome, style: const TextStyle(fontSize: 18)),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(local.logout),
            onTap: () => Navigator.pushReplacementNamed(context, Routes.login),
          ),
        ],
      ),
    );
  }
}
