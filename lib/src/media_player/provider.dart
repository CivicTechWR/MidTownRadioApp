import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerService playerService;
  bool _isLoading = false;
  bool _isFullScreen = false;

  // keep track of if player is fullscreen view
  set isFullScreen(isFull){
    _isFullScreen = isFull;
    notifyListeners();
  }

  bool get isFullScreen => _isFullScreen;

  PlayerProvider(this.playerService);

  String? get currentSreamUrl => playerService.currentStreamUrl;
  
  bool get isPlaying => playerService.player.playing;
  bool get isLoading => _isLoading;
  

  Future<void> setStream(String url) async {
    _isLoading = true;
    notifyListeners();

    await playerService.setStream(url);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> play() async {
    // before we were awaiting play, but I think since were streaming it never ends
    // and so we couldnt do anything while playing music
    // by not awaiting it we can do other things and it works asynchronously to play
    playerService.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await playerService.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await playerService.stop();
    notifyListeners();
  }
}