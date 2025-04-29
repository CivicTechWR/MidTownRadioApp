import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class PlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentStreamUrl;

  AudioPlayer get player => _audioPlayer;
  String? get currentStreamUrl => _currentStreamUrl;

  late AudioSession session;

  Future<void> init() async {
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    session.becomingNoisyEventStream.listen((_) {
      _audioPlayer.pause();
    });
  }

  Future<void> setStream(String url) async {
    if (_currentStreamUrl == url) return;

    try {
      _currentStreamUrl = url;
      await _audioPlayer.setUrl(url);
      // _audioPlayer.play();
      play();
    // if (await session.setActive(true)) {
    //   await _audioPlayer.play();
    //   MediaControl.play;
    // }

    } catch (e) {
      stop();
      rethrow;
    }
  }

  Future<void> play() async {
    if (await session.setActive(true)) {
      await _audioPlayer.play();
      MediaControl.play;
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    MediaControl.pause;
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    await session.setActive(false);
      _currentStreamUrl = null;
    MediaControl.stop;
    _audioPlayer.dispose();
  }
}
