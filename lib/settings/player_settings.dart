import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerSettings {
  final _assetsAudioPlayer = AssetsAudioPlayer();
  late Stream<bool> isAudioPlayerPlaying;
  late Stream<Playing?> currentValues;
  late bool? notifications;
  late bool isFavoriteValue;
  static final AudioPlayerSettings _singleton = AudioPlayerSettings._internal();

  factory AudioPlayerSettings() {
    return _singleton;
  }
  AudioPlayerSettings._internal();
  Future<void> initializeAudioPlayerWithAudios(
      List<Audio> audios, index,) async {
    print(audios);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications = await prefs.getBool('notification');
    _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: index),
      loopMode: LoopMode.playlist,
      autoStart: true,
    );
    _assetsAudioPlayer.showNotification = notifications ?? true;
    isAudioPlayerPlaying = _assetsAudioPlayer.isPlaying;
    currentValues = _assetsAudioPlayer.current;
    //isFavoriteValue = isFavorite;
  }

  Future<void> audioPlayerSings(List audiosList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifications = await prefs.getBool('notification');
    final List<Audio> audioData = (audiosList)
        .map((audio) => Audio.file(audio['uri'],
            metas: Metas(
                title: audio['title'],
                artist: audio['artist'],
                id: audio['id'].toString(),
                extra: {'isFavorite': audio['isFavorite']})))
        .toList();
    _assetsAudioPlayer.open(
      Playlist(audios: audioData),
      loopMode: LoopMode.playlist,
      autoStart: true,
    );
    _assetsAudioPlayer.showNotification = notifications ?? false;
    isAudioPlayerPlaying = _assetsAudioPlayer.isPlaying;
    currentValues = _assetsAudioPlayer.current;
  }

  Future<void> playOrPauseAudio() async {
    await _assetsAudioPlayer.playOrPause();
  }

  Future<void> pauseAudio() async {
    await _assetsAudioPlayer.pause();
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

  Future<void> seek(Duration to) async {
    await _assetsAudioPlayer.seek(to);
  }

  Future<void> seekByForward() async {
    await _assetsAudioPlayer.seekBy(const Duration(seconds: 10));
  }

  Future<void> seekByBackward() async {
    await _assetsAudioPlayer.seekBy(const Duration(seconds: -10));
  }

  Widget infos() {
    return Container(
      child: _assetsAudioPlayer.builderRealtimePlayingInfos(
          builder: (BuildContext context, RealtimePlayingInfos? infos) {
        if (infos == null) {
          return Container();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, bottom: 40.0, left: 30, right: 30),
              child: ProgressBar(
                //bufferedBarColor: Colors.grey,
                baseBarColor: Colors.grey[500],
                progressBarColor: Colors.black,
                thumbColor: Colors.blueGrey,
                progress: infos.currentPosition,
                total: infos.duration,
                onSeek: (to) {
                  _assetsAudioPlayer.seek(to);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
