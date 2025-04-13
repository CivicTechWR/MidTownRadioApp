import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/widget.dart';
// import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';
import 'package:ctwr_midtown_radio_app/main.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';

class ListenLivePage extends StatelessWidget {
  const ListenLivePage({super.key});

  static const routeName = '/listen_live';



  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => playerProvider.setStream('https://midtownradiokw.out.airtime.pro/midtownradiokw_a'), 
            child: Icon(Icons.play_arrow, size: 100),
          ),
          // Icon(Icons.radio, size: 100),
          // PlayerWidget(),
          SizedBox(height: 20),
          Text(
            'Listen Live!',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,),
          ),
          SizedBox(height: 10),
          PlayerWidget()
        ],
      )
    );
  }
}
