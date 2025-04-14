import 'package:flutter/material.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/provider.dart';

class FullScreenPlayer extends StatelessWidget {
  const FullScreenPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset('assets/images/logo_mic_black_on_white.png',
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Midtown Radio KW',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                playerProvider.isLoading ? CircularProgressIndicator() : Text('Live'),
              ],
            ),
          ),

          // play/pause
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 50,
                      icon: Icon(playerProvider.isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (playerProvider.isPlaying) {
                          playerProvider.pause();
                        } else {
                          playerProvider.play();
                        }
                      }
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
