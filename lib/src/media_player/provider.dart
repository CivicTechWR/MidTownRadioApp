import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerService _playerService;
  bool _isLoading = false;

  PlayerProvider(this._playerService);

  String? get currentSreamUrl => _playerService.currentStreamUrl;
  
  bool get isPlaying => _playerService.player.playing;
  bool get isLoading => _isLoading;
  

  Future<void> setStream(String url) async {
    _isLoading = true;
    notifyListeners();

    await _playerService.setStream(url);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> play() async {
    // if we awaiut play/pause, my play/pause button, based off of isPlaying does not work properly
    // it works perfectly like this, maybe we can look into it but this works
    _playerService.play();
    notifyListeners();
  }

  Future<void> pause() async {
    _playerService.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _playerService.stop();
    notifyListeners();
  }
}