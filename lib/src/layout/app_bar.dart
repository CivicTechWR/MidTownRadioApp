import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/layout/drawer.dart';

import 'package:ctwr_midtown_radio_app/src/settings/view.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Theme.of(context).brightness == Brightness.dark
      ? Image.asset('assets/images/logo_main.png',
        fit: BoxFit.cover,
        height: 120,
      )
      : Image.asset('assets/images/logo_main.png',
        fit: BoxFit.cover,
        height: 120,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}