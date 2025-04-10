import 'package:flutter/material.dart';

class InfoDrawer extends StatefulWidget {
  const InfoDrawer({super.key});

  @override
  State<InfoDrawer> createState() => _InfoDrawerState();
}

class _InfoDrawerState extends State<InfoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "This is A side Info Drawer!!",
        style: TextStyle(
          fontSize: 32,
        ),
      )
    );
  }
}