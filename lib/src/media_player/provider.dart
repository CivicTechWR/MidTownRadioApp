import 'package:flutter/material.dart';
import 'package:ctwr_midtown_radio_app/src/media_player/service.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerService _playerService;

  PlayerProvider(this._playerService);

  String? get currentSreamUrl => _playerService.currentStreamUrl;
  bool get isPlaying => _playerService.player.playing;

  Future<void> setStream(String url) async {
    await _playerService.setStream(url);
    notifyListeners();
  }

  Future<void> play() async {
    await _playerService.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _playerService.pause();
    notifyListeners();
  }

  Future<void> stop() async {
    await _playerService.stop();
    notifyListeners();
  }
}