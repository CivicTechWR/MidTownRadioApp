// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';

// import 'package:provider/provider.dart';
// import 'package:flutter_test/flutter_test.dart';

// // import 'package:ctwr_midtown_radio_app/main.dart';
// import 'package:ctwr_midtown_radio_app/src/app.dart';
// import 'package:ctwr_midtown_radio_app/src/settings/controller.dart';
// import 'package:ctwr_midtown_radio_app/src/settings/service.dart';

// import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';
// import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     final settingsController = SettingsController(SettingsService());

//     final playerService = PlayerService();
//     await playerService.init();
//     settingsController.loadSettings();
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(ChangeNotifierProvider(
//         create: (_) => PlayerProvider(playerService),
//         child: MidtownRadioApp(settingsController: settingsController)));

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
