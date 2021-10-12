import 'package:flutter/material.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';

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

  @override
  void initState() {
    super.initState();
    audioPlayer.setAsset('assets/music/song.mp3');
    audioPlayer.play();
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
                          isPlaying = true;
                        },
                        icon: const Icon(Icons.favorite_border)),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.playlist_add),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder<DurationState>(
            stream: _durationState,
            builder: (context, snapshot) {
              final durationState = snapshot.data;
              final progress = durationState?.progress ?? Duration.zero;
              final buffered = durationState?.buffered ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ProgressBar(
                  progress: progress,
                  buffered: buffered,
                  total: total,
                  onSeek: (duration) {
                    audioPlayer.seek(duration);
                  },
                  thumbColor: Colors.black,
                  baseBarColor: Colors.grey,
                  bufferedBarColor: Colors.grey,
                  progressBarColor: Colors.black,
                ),
              );
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Row(
          //     children: [
          //       const Text('00:00'),
          //       Expanded(
          //         child: SliderTheme(
          //             data: const SliderThemeData(
          //               thumbColor: Colors.black,
          //               inactiveTrackColor: Colors.grey,
          //             ),
          //             child: Slider(value: 0, onChanged: (value) {})),
          //       ),
          //       const Text('03:40')
          //     ],
          //   ),
          // ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Icon(Icons.skip_previous),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: IconButton(
                iconSize: 35,
                icon: Icon(btnIcon),
                onPressed: () {
                  if (isPlaying) {
                    audioPlayer.pause();
                    setState(() {
                      isPlaying = false;
                      btnIcon = Icons.play_arrow;
                    });
                  } else {
                    audioPlayer.play();
                    setState(() {
                      isPlaying = true;
                      btnIcon = Icons.pause;
                    });
                  }
                  print(isPlaying);
                },
              ),
            ),
            const Icon(Icons.skip_next),
          ])
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
