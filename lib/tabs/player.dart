import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_player/player/position_seek_widget.dart';

class CurrentMusic extends StatefulWidget {
  final List musicList;
  const CurrentMusic({
    Key? key,
    required this.musicList,
  }) : super(key: key);

  @override
  _CurrentMusicState createState() => _CurrentMusicState();
}

class _CurrentMusicState extends State<CurrentMusic> {
  bool isPlaying = false;
  String currentSong = "";
  AudioPlayer audioPlayer = AudioPlayer();
  late Stream<DurationState> _durationState;

  late AudioHandler _audioHandler;
  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration _duration = new Duration();
  Duration _position = new Duration();

  @override
  void initState() {
// Future<AudioHandler> initAudioService() async {
//   return await AudioService.init(
//     builder: () => AudioPlayerHandler(),
//     config: AudioServiceConfig(
//       androidNotificationChannelId: 'com.mycompany.myapp.audio',
//       androidNotificationChannelName: 'Audio Service Demo',
//       androidNotificationOngoing: true,
//       androidStopForegroundOnPause: true,
//     ),
//   );
// }
    super.initState();
    // audioPlayer.setAsset('assets/music/song.mp3');
    // audioPlayer.play();
    assetsAudioPlayer.open(
        Audio(
          "assets/music/song.mp3",
          metas: Metas(
            title: widget.musicList[0]['title'],
            artist: widget.musicList[0]['artist'],
            //album: "CountryAlbum",
            image: MetasImage.asset(
                widget.musicList[0]['image']), //can be MetasImage.network
          ),
        ),
        autoStart: true,
        showNotification: true);
    _durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        audioPlayer.positionStream,
        audioPlayer.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration!,
            ));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  IconData btnIcon = Icons.pause;
  IconData favIcon = Icons.favorite_border;
  Color colorFav = Colors.grey;

  //late String tracks = this.tracks;
  @override
  Widget build(BuildContext context) {
    List music = widget.musicList;
    // void playMusic(String url) async {
    //   if (isPlaying && currentSong != url) {
    //     audioPlayer.pause();
    //     int result = await audioPlayer.play(url);
    //     if (result == 1) {
    //       setState(() {
    //         currentSong = url;
    //       });
    //     } else if (!isPlaying) {
    //       int result = await audioPlayer.play(url);
    //       if (result == 1) {
    //         setState(() {
    //           isPlaying = true;
    //         });
    //       }
    //     }
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          'Melomaniac',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Genera'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
              height: 200,
              width: 200,
              // decoration: BoxDecoration(
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.5
              // ),
              // ),
              //     ],
              //     ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(music[0]['image']))),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        music[0]['title'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Genera',
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        music[0]['artist'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Genera',
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 55,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          favIcon = Icons.favorite;
                          colorFav = Colors.red;
                        });
                      },
                      icon: Icon(favIcon, color:colorFav),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.playlist_add),
                  ],
                )
              ],
            ),
          ),
          // StreamBuilder<DurationState>(
          //   stream: _durationState,
          //   builder: (context, snapshot) {
          //     final durationState = snapshot.data;
          //     final progress = durationState?.progress ?? Duration.zero;
          //     final buffered = durationState?.buffered ?? Duration.zero;
          //     final total = durationState?.total ?? Duration.zero;
          //     return Padding(
          //       padding: const EdgeInsets.all(15.0),
          //       child: ProgressBar(
          //         progress: progress,
          //         buffered: buffered,
          //         total: total,
          //         onSeek: (duration) {
          //           audioPlayer.seek(duration);
          //         },
          //         thumbColor: Colors.black,
          //         baseBarColor: Colors.grey,
          //         bufferedBarColor: Colors.grey,
          //         progressBarColor: Colors.black,
          //       ),
          //     );
          //   },
          //),
//           StreamBuilder<Duration>(
// stream: assetsAudioPlayer.currentPosition,
// builder: (BuildContext context, AsyncSnapshot <Duration> snapshot) {

// final Duration _currentDuration = snapshot.data!;
// final int _milliseconds = _currentDuration.inMilliseconds;
// final int _songDurationInMilliseconds = snapshot.data!.inMilliseconds;

// return Slider(
//     min: 0,
//     max: _songDurationInMilliseconds.toDouble(),
//     value: _songDurationInMilliseconds > _milliseconds
//             ? _milliseconds.toDouble()
//             : _songDurationInMilliseconds.toDouble(),
//     onChanged: (double value) {
//     assetsAudioPlayer.seek(Duration(milliseconds: (value / 1000.0).toInt()));
//     },
//     activeColor: Colors.blue,
//     inactiveColor: Colors.grey,
//   );
// },
// ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, RealtimePlayingInfos? infos) {
            if (infos == null) {
              return SizedBox();
            }
            //print('infos: $infos');
            return Column(
              children: [
                PositionSeekWidget(
                  currentPosition: infos.currentPosition,
                  duration: infos.duration,
                  seekTo: (to) {
                    assetsAudioPlayer.seek(to);
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: -10));
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: -10));
                      },
                      icon: Icon(Icons.skip_previous),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black,
                      child: IconButton(
                        iconSize: 35,
                        icon: Icon(btnIcon, color: Colors.white),
                        onPressed: () {
                          if (isPlaying) {
                            //audioPlayer.pause();
                            assetsAudioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                              btnIcon = Icons.play_arrow;
                            });
                          } else {
                            assetsAudioPlayer.play();
                            setState(() {
                              isPlaying = true;
                              btnIcon = Icons.pause;
                            });
                          }
                          print(isPlaying);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: -10));
                      },
                      icon: Icon(Icons.skip_next),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: 10));
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                )
              ],
            );
          }),

          // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //   const Icon(Icons.skip_previous),
          //   CircleAvatar(
          //     radius: 30,
          //     backgroundColor: Colors.black,
          //     child: IconButton(
          //       iconSize: 35,
          //       icon: Icon(btnIcon),
          //       onPressed: () {
          //         if (isPlaying) {
          //           //audioPlayer.pause();
          //           assetsAudioPlayer.pause();
          //           setState(() {
          //             isPlaying = false;
          //             btnIcon = Icons.play_arrow;
          //           });
          //         } else {
          //           assetsAudioPlayer.play();
          //           setState(() {
          //             isPlaying = true;
          //             btnIcon = Icons.pause;
          //           });
          //         }
          //         print(isPlaying);
          //       },
          //     ),
          //   ),
          //   const Icon(Icons.skip_next),
          // ])
        ],
      ),
    );
  }
}

class DurationState {
  const DurationState(
      {required this.progress, required this.buffered, required this.total});
  final Duration progress;
  final Duration buffered;
  final Duration total;
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  final _player = AudioPlayer();

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    mediaItem.add(_item);

    // Load the player.
    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
