import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/layout/app_bar.dart';
import 'package:ctwr_midtown_radio_app/src/listen_live/view.dart';
import 'package:ctwr_midtown_radio_app/src/on_demand/view.dart';
import 'package:ctwr_midtown_radio_app/src/layout/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MainAppBar(),
        drawer: const MainAppDrawer(),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.radio),
                  text: 'Listen Live'
                ),
                Tab(
                  icon: Icon(Icons.podcasts),
                  text: 'On Demand'
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListenLivePage(),
                  OnDemandPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}