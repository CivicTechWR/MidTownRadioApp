import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
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
              playerProvider.currentSreamUrl ?? 'No stream selected',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]
      )
    );
  }

}