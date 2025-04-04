import 'package:flutter/material.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async => ThemeMode.light;

  Future<void> updateThemeMode(ThemeMode themeMode) async {}
}