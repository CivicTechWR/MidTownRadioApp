import 'package:flutter/material.dart';
import 'controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
    required this.controller,
    });

  static const routeName = '/settings';
  static const String title = 'Settings';

  final SettingsController controller;

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.controller.themeMode;
  }

  void _updateThemeMode(ThemeMode? newThemeMode) {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    setState(() {
      _themeMode = newThemeMode;
    });
    widget.controller.updateThemeMode(newThemeMode);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('App Settings'),
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButton<ThemeMode>(
                  value: _themeMode,
                  onChanged: _updateThemeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                  ],
                )),
          ],
        ));
  }
}
