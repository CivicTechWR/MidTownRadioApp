import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/widget.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/fullscreen_player.dart';

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
          playerProvider.isLoading
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            )
          : ElevatedButton(
            onPressed: () {
              
              // first click loads stream, starts stream, and pops up full screen
              if (playerProvider.currentSreamUrl == null){
                playerProvider.setStream('https://midtownradiokw.out.airtime.pro/midtownradiokw_a');
                playerProvider.play();
                PlayerWidget.showPlayerSheet(context);
              // after first click, when music is already loaded its a play/pause
              } else if (playerProvider.isPlaying){
                playerProvider.pause();
              } else{
                playerProvider.play();
              }
              
            }, 
            child: Icon(playerProvider.isPlaying ? Icons.pause : Icons.play_arrow, size: 100),
          ),
          
          const SizedBox(height: 20),
          const Text(
            'Listen Live!',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          //const PlayerWidget(),
        ],
      ),
    );
  }

 void _showPlayerSheet(BuildContext context) {
   final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
   
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.viewPadding.top;
    final screenHeight = mediaQuery.size.height;

    playerProvider.isFullScreen = true;
    
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      
      context: context,
      isScrollControlled: true,

      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: screenHeight,
        margin: EdgeInsets.only(top: safePadding),
        child: FullScreenPlayer(),
      ),
    ).then((_) {
      playerProvider.isFullScreen = false;
    });
  }
}