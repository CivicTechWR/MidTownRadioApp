import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/fullscreen_player.dart';


class PlayerWidget extends StatelessWidget {
  const PlayerWidget({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return GestureDetector(
      onTap:() => _showPlayerSheet(context),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          children: [
            playerProvider.isLoading ? Padding(
              padding: const EdgeInsets.all(8.0), // Same padding as IconButton
              child: SizedBox(
                width: 24, // Typical icon button size
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0, // Make it thinner to match material design
                ),
              ),
            )
            : IconButton(
              icon: Icon(playerProvider.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (playerProvider.isPlaying) {
                  playerProvider.pause();
                } else if (playerProvider.currentSreamUrl != null) {
                  playerProvider.play();
                }
              },
            ),
            
            Expanded(
              child: Text(
                // we should probably create a map in the provider from a URL to a title to display.
                // for now, I will assume that only the live could be playing, but this will have to adapt 
                // once we implement on demand listening
                playerProvider.isPlaying ? "Midtown Radio KW Live" : 'No stream selected',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]
        )
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