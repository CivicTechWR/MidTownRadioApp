import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/app.dart';
import 'package:ctwr_midtown_radio_app/src/settings/controller.dart';
import 'package:ctwr_midtown_radio_app/src/settings/service.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';


void main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());
  
  final playerService = PlayerService();
  await playerService.init();

  // Load settings
  await settingsController.loadSettings();

  // Load settings
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(ChangeNotifierProvider(
    create: (_) => PlayerProvider(playerService),
    child: MidtownRadioApp(settingsController: settingsController)));
}