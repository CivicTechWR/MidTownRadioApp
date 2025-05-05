import 'package:ctwr_midtown_radio_app/main.dart';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class PlayerWidget extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const PlayerWidget({
    super.key,
    required this.navigatorKey
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.viewPadding.bottom;
    final theme = Theme.of(context);

    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder:(context, snapshot) {
        final isPlaying = audioPlayerHandler.isPlaying;
        return Container(
      
      // can adjust this margin to raise this widget - I picked +20 arbitrairily
      // safePadding puts it above any OS buttons like the IOS home swipe bar, so it should stay
      padding: EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
        bottom: safePadding + 30,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        //color: Colors.grey[200],
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // play/pause button
          snapshot.data?.processingState == AudioProcessingState.buffering
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(isPlaying
                    ? Icons.pause
                    : Icons.play_arrow),
                  onPressed: () {
                    if (isPlaying) {
                      audioHandler.pause();
                    } else if (audioPlayerHandler.isCurrentlyPlaying.isNotEmpty && audioPlayerHandler.isCurrentlyPlaying != "Nothing is loaded...") {
                      audioHandler.play();
                    }
                  },
                ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Now Playing:",
                  style: TextStyle(
                    fontSize: 12,
                  )
                ),
                Text(
                  audioPlayerHandler.isCurrentlyPlaying,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}}