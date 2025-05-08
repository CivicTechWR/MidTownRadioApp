import 'package:flutter/material.dart';

import 'package:ctwr_midtown_radio_app/src/settings/view.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset('assets/images/logo_main.png',
        fit: BoxFit.cover,
        height: 55,
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Image.asset("assets/images/hashtag-local-af.png", height: 18,),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}