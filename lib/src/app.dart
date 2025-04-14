import 'package:ctwr_midtown_radio_app/src/settings/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/widget.dart'; 
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';
import 'package:ctwr_midtown_radio_app/src/settings/view.dart';
import 'package:ctwr_midtown_radio_app/src/error/view.dart';
import 'package:ctwr_midtown_radio_app/src/home/view.dart';
import 'package:ctwr_midtown_radio_app/src/listen_live/view.dart';
import 'package:ctwr_midtown_radio_app/src/on_demand/view.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';

class MidtownRadioApp extends StatelessWidget {
  const MidtownRadioApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final playerService = PlayerService();
    return ChangeNotifierProvider(
      create: (_) => PlayerProvider(playerService),
      child: MidtownRadioStateful(settingsController: settingsController),
    );
  }
}

class MidtownRadioStateful extends StatefulWidget {
  const MidtownRadioStateful({
    Key? key,
    required this.settingsController
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  MidtownRadioState createState() => MidtownRadioState();
}

class MidtownRadioState extends State<MidtownRadioStateful> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          navigatorKey: navigatorKey,

          // wraps with scaffold to display persistent bottom controller bar when radio is playing
          builder: (context, child) => Scaffold(
            body: child,
            bottomSheet: Consumer<PlayerProvider>(
              builder: (context, player, _) {
                // displays bottom only if music is playing and not full screen view
                return (player.currentSreamUrl != null && !player.isFullScreen)
                    ? PlayerWidget(navigatorKey: navigatorKey)
                    : const SizedBox.shrink();
              },
            ),
          ),
          
          initialRoute: HomePage.routeName,
          
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en', ''),
            Locale('fr', ''),
          ],

          onGenerateTitle: (BuildContext context) => 
              AppLocalizations.of(context)!.appTitle,

          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,

          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case HomePage.routeName:
                    return const HomePage();
                  case ListenLivePage.routeName:
                    return const ListenLivePage();
                  case OnDemandPage.routeName:
                    return const OnDemandPage();
                  case SettingsPage.routeName:
                    return SettingsPage(controller: widget.settingsController);
                  default:
                    return const ErrorPage();
                }
              }
            );
          },
        );
      }
    );
  }
}