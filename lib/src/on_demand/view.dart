import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';

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

  const OnDemandPage({super.key, required this.showList, required this.updatePlayer});

   */

  const OnDemandPage({super.key});
  static const routeName = '/on_demand';
  final String title = 'On Demand';

  @override
  State<OnDemandPage> createState() => _ShowListState();
}

class _ShowListState extends State<OnDemandPage> {

  String currentMedia = "";
  bool isPlaying = false;

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
    final playerProvider = Provider.of<PlayerProvider>(context);
    return ListView.builder(itemCount: showList.length, itemBuilder: (context, index) {
      final show = showList[index];
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: (Theme.of(context).brightness == Brightness.dark) ? Color.fromARGB(255, 49, 49, 49) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color:Colors.blueGrey,
                  blurRadius: 3,
                  offset: Offset(1, 1),
                )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Row(children: [
                      Image.asset(show.imgUrl, width: 125,),
                      Expanded(
                        child: Center(
                          child: Text(show.title,
                          style: Theme.of(context).textTheme.headlineSmall,),
                        ),
                      )
                    ],),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(show.desc),
                    ),
                    ListView.builder(itemCount: show.episodes.length, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemBuilder: (context, index) {
                    final episode = show.episodes[index];
                    return Row(
                      children: [
                        IconButton(onPressed: ()=>{
                          setState(() {
                            if (currentMedia != episode.mediaUrl) {
                              currentMedia = episode.mediaUrl;
                              playerProvider.setStream(episode.mediaUrl);
                              playerProvider.play();
                              isPlaying = true;
                            } else {
                              if (isPlaying) {
                                playerProvider.pause();
                              } else {
                                playerProvider.play();
                              }
                              isPlaying = !isPlaying;
                            }
                          })
                        }, icon: Icon(((currentMedia == episode.mediaUrl) && isPlaying) ? Icons.pause : Icons.play_arrow)),
                        Text(episode.title),
                      ],
                    );
                  })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}