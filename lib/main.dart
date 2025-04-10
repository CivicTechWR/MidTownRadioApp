import 'package:flutter/material.dart';
import 'widgets/audio_player_bottomsheet.dart';
import 'widgets/live_listening_page.dart';
import 'widgets/ondemand_listening_page.dart';
import 'widgets/info_drawer.dart';
// I have created separate widgets for each page, drawer, and the bottom audio bar.
// these can be found to edit in widgets/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _displayBottomSheet = false;

  void _toggleBottomSheet() {
    setState(() {
      // setstate rebuilds with new changes - here the change is that we want to display the bottom sheet
      // which is conditional upon this variable
      _displayBottomSheet = !_displayBottomSheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 2,
      child: Scaffold(

        // top appbar with logo and selecting pages
        appBar: AppBar(

          // hamburger button to open side drawer
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Image.asset(
            'assets/WORDMARK PNG.png',
            height: 120,
          ),
          // page selection
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text("Live")
              ),
              Tab(
                child: Text("On Demand")
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [

            // I abstracted away this page into its own component, in widgets/live_listening_page.dart
            LiveListeningPage(),
            
            OnDemandListeningPage()
          ],
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleBottomSheet,
          
          child: const Text("audio!"),
          
        ), // This trailing comma makes auto-formatting nicer for build methods.
      
        // we render the bottom sheet if _displayBottomSheet is true, else we render nothing (pass null argument)
        // the AudioBottomSheet is a custom widget (like component), found in widgets/audio_player_bottomsheet.dart
        bottomSheet: _displayBottomSheet ? AudioBottomSheet() : null,

        drawer: Drawer(
          // info drawer is a custom widget, found in widgets/
          // the name is generic cuz i dont hactually know what we want here... ?
          child: InfoDrawer(),
        ),
          
        
      ),
    );
  }
}

