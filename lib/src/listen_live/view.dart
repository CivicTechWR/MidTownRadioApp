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
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);
    

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              playerProvider.setStream('https://midtownradiokw.out.airtime.pro/midtownradiokw_a');
              playerProvider.play();

              _showPlayerSheet(context);
            }, 
            child: const Icon(Icons.play_arrow, size: 100),
          ),
          const SizedBox(height: 20),
          const Text(
            'Listen Live!',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const PlayerWidget(),
        ],
      ),
    );
  }

  void _showPlayerSheet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.viewPadding.top;
    final screenHeight = mediaQuery.size.height;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: screenHeight * 0.9,
        margin: EdgeInsets.only(top: safePadding + 10), // Extra 10 for breathing room
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea( // Additional protection
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
              ),),
              Expanded(child: FullScreenPlayer()),
            ],
          ),
        ),
      ),
    );
  }
}