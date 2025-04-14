import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class PlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentStreamUrl;

  AudioPlayer get player => _audioPlayer;
  String? get currentStreamUrl => _currentStreamUrl;

  late AudioSession session;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      ),
    );
    session.setActive(true);
  }

  Future<void> setStream(String url) async {
    if (_currentStreamUrl == url) return;

    print("This ran 1");
    try {
      // if (await session.setActive(true)) {
          print("This ran 2");

        _currentStreamUrl = url;
        await _audioPlayer.setUrl(url);
            print("This ran 3");

        _audioPlayer.play();
  

      // }
    } catch (e) {
      _currentStreamUrl = null;
      rethrow;
    }
        print("This ran 5");

  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
