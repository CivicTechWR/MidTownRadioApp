import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerService playerService;
  bool _isLoading = false;

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