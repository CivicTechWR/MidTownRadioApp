import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/fullscreen_player.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';

class PlayerWidget extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const PlayerWidget({
    super.key,
    required this.navigatorKey
  });

  // if user taps on bottom control bar, this gets called and fullscreen pops up
  static void showPlayerSheet(BuildContext context) {
   final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
   
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    final mediaQuery = MediaQuery.of(rootContext);
    final safePadding = mediaQuery.viewPadding.top;
    final screenHeight = mediaQuery.size.height;

    playerProvider.isFullScreen = true;
    
    showModalBottomSheet(
      barrierColor: Colors.transparent,
      
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,

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

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final safePadding = mediaQuery.viewPadding.bottom;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () =>showPlayerSheet(navigatorKey.currentContext!),
      child: Container(
        
        // can adjust this margin to raise this widget - I picked +20 arbitrairily
        // safePadding puts it above any OS buttons like the IOS home swipe bar, so it should stay
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
          bottom: safePadding + 20,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          //color: Colors.grey[200],
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            // play/pause button
            playerProvider.isLoading
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
                    icon: Icon(playerProvider.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                    onPressed: () {
                      if (playerProvider.isPlaying) {
                        playerProvider.pause();
                      } else if (playerProvider.currentSreamUrl != null) {
                        playerProvider.play();
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
                    (playerProvider.currentSreamUrl != null)
                        ? "Midtown Radio KW Live"
                        : 'No stream selected',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
