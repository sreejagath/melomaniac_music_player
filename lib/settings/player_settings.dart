import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayerSettings {
  final _assetsAudioPlayer = AssetsAudioPlayer();
  late Stream<bool> isAudioPlayerPlaying;
  late Stream<Playing?> currentStatus;
  static final AudioPlayerSettings _singleton = AudioPlayerSettings._internal();

  factory AudioPlayerSettings() {
    return _singleton;
  }
  AudioPlayerSettings._internal();
  Future<void> initializeAudioPlayerWithAudios(List<Audio> audios,index) async {
    _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: index),
      loopMode: LoopMode.playlist,
      autoStart: true,
    );
    _assetsAudioPlayer.showNotification = true;
    isAudioPlayerPlaying = _assetsAudioPlayer.isPlaying;
    currentStatus = _assetsAudioPlayer.current;
  }

  Future<void> playOrPauseAudio() async {
    await _assetsAudioPlayer.playOrPause();
  }

  Future<void> playNext() async {
    await _assetsAudioPlayer.next();
  }

  Future<void> playPrevious() async {
    await _assetsAudioPlayer.previous();
  }

  Future<void> playSongAtIndex(int index) async {
    _assetsAudioPlayer.playlistPlayAtIndex(index);
  }

  Future<void> stopSongs() async {
    await _assetsAudioPlayer.stop();
  }
}
