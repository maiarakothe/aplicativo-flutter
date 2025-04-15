import 'package:flutter/material.dart';
import 'app_drawer.dart';

class ResponsiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width >= 800;

    if (isLargeScreen) {
      return Row(
        children: [
          const Material(child: AppDrawer()),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              backgroundColor: Theme.of(context).cardColor,
              appBar: appBar,
              body: body,
              floatingActionButton: floatingActionButton,
            ),
          ),
        ],
      );
    } else {
      final Widget? appBarWithMenu = appBar != null
          ? AppBar(
        title: (appBar as AppBar).title,
        actions: (appBar as AppBar).actions,
        automaticallyImplyLeading: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      )
          : null;

      return Scaffold(
        drawer: const AppDrawer(),
        appBar: appBarWithMenu as PreferredSizeWidget?,
        body: body,
        floatingActionButton: floatingActionButton,
      );
    }
  }
}
