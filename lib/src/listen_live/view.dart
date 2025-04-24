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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    playerProvider.setStream('https://midtownradiokw.out.airtime.pro/midtownradiokw_a');
                    if (playerProvider.isPlaying) {
                      playerProvider.pause();
                      } else {
                        playerProvider.play();
                      }
                    }, 
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size.fromRadius(100)),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(10))),
                  child: Stack(alignment: AlignmentDirectional.center,children: [
                    Container(
                      width: 150, 
                      height: 150, 
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff005c5f),Color(0xff00989d),Color(0xff33cccc)],
                          begin: Alignment.bottomCenter,
                          end:Alignment.topCenter,
                          ),
                          shape:BoxShape.circle,
                          ),),
                    Icon(playerProvider.isPlaying ? Icons.pause:Icons.play_arrow,size: 100, color: Color.fromRGBO(217, 217, 216, 0.9),)
                    ]),
                ),
                // Icon(Icons.radio, size: 100),
                // PlayerWidget(),
                // SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    'Live Listening',
                    style: TextStyle(
                      color: Color(0xfff05959),
                      fontSize: 34,
                      fontWeight: FontWeight.bold,),
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
          PlayerWidget()
        ],
      )
    );
  }
}
