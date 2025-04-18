import 'package:flutter/material.dart';

class Episode {
  final String title;
  final String mediaUrl; 

  Episode({
    required this.title,
    required this.mediaUrl,
  });
}

class Show {
  final String title;
  final String desc;
  final String imgUrl;
  final List<Episode> episodes;

  Show({
    required this.title,
    required this.desc,
    required this.imgUrl,
    required this.episodes,
  });
}  

class OnDemandPage extends StatefulWidget {
  /* 
  
  This widget will take 2 parameters: the array of shows from the api and the function to update the player. For now I'll just put somthing random in.

  final List<Show> showList;
  final void Function(String mediaUrl) updatePlayer;

  const OnDemandPage({super.key, required this.showList, required this.updatePlayer});

   */

  const OnDemandPage({super.key});
  static const routeName = '/on_demand';
  final String title = 'On Demand';

  @override
  State<OnDemandPage> createState() => _ShowListState();
}

class _ShowListState extends State<OnDemandPage> {
  final List<Show> showList = [
    Show(title: "Test 1", desc: "The first of many", imgUrl: 'assets/images/logo_mic_black_on_white.png', episodes:[
      Episode(title: "Episode 1", mediaUrl: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a'),
      Episode(title: "Episode 2", mediaUrl: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a'),
      Episode(title: "Episode 3", mediaUrl: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a'),
    ]),
    Show(title: "Test 2", desc: "electric boogaloo", imgUrl: 'assets/images/logo_mic_black_on_white.png', episodes:[
      Episode(title: "Episode One", mediaUrl: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a'),
      Episode(title: "Episode Two", mediaUrl: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a'),
      Episode(title: "Episode Three", mediaUrl: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: showList.length, itemBuilder: (context, index) {
      final show = showList[index];
      return Column(
        children: [
          Row(children: [
            Image.asset(show.imgUrl, height: 100,),
            Column(children: [
              Text(show.title),
              Text(show.desc)
            ],)
          ],),
        ],
      );
    });
  }
}