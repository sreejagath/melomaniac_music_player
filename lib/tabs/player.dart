import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/player/position_seek_widget.dart';
import 'package:music_player/settings/player_settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_player/main.dart';
import 'package:hive/hive.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentMusic extends StatefulWidget {
  final List musicList;
  int currentIndex;
  CurrentMusic({
    Key? key,
    required this.musicList,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _CurrentMusicState createState() => _CurrentMusicState();
}

class _CurrentMusicState extends State<CurrentMusic> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool isPlaying = false;
  String trackArtist = "";
  String trackTitle = "";
  int trackId = 0;
  int track = 0;
  List favorite = [];
  List favorites = [];
  bool? notifications;
  List pathsForPlaying = [];
  Duration? duration;
  bool isFavorite = false;
  final assetsAudioPlayer = AssetsAudioPlayer();

  Future<bool> notification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification') ?? true;
  }

  setSongId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', widget.musicList[widget.currentIndex]['id']);
    return prefs.getInt('id');
  }

  Future<int> getSongId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id')!;
  }

  var audiosForPlaying = <Audio>[];
  Future<void> initializeAudiosForPlaying() async {
    for (var i = 0; i < widget.musicList.length; i++) {
      pathsForPlaying.add(widget.musicList[i]['uri']);
    }
    await Future.forEach(pathsForPlaying, (path) async {
      audiosForPlaying.addAll(widget.musicList[widget.currentIndex]['uri']);
    });
  }

  final audioPlayerSettings = AudioPlayerSettings();

  // Future<bool> favoriteList() async {
  //   bool isFav = false;
  //   var favoriteList = await Hive.openBox('favorites');
  //   favorite = favoriteList.get('favorites');
  //   print(favorite);
  //   for (var i = 0; i < favorite.length; i++) {
  //     if (favorite[i]['id'] == widget.musicList[widget.currentIndex]['id']) {
  //       isFav = true;
  //       print('isFavorite');
  //     }
  //   }
  //   return isFav;
  // }
  favoriteList() {
    var favoriteList = Hive.box('favorites').get(widget.musicList[widget.currentIndex]['id']);
    if (favoriteList != null) {
      isFavorite = true;
    }
  }

  @override
  void initState() {
    favoriteList();
    final List<Audio> audios = (widget.musicList)
        .map((audio) => Audio.file(audio['uri'],
            metas: Metas(
                title: audio['title'],
                artist: audio['artist'],
                id: audio['id'].toString(),
                extra: {'isFavorite': audio['isFavorite']})))
        .toList();
    audioPlayerSettings
        .initializeAudioPlayerWithAudios(
      audios,
      widget.currentIndex,
    )
        .then((value) {
      audioPlayerSettings.currentValues.listen((current) {
        if (mounted) {
          if (current == null) {
            return;
          } else {
            setState(() {
              print(current);
              trackTitle = current.audio.audio.metas.title ?? 'No Title';
              trackArtist = current.audio.audio.metas.artist ?? 'No Artist';
              trackId = int.parse(current.audio.audio.metas.id!);
              isFavorite = current.audio.audio.metas.extra!['isFavorite'];
              print(isFavorite);
            });
          }
        }
      });
    }).then((value) =>
            audioPlayerSettings.isAudioPlayerPlaying.listen((isPlaying) {
              if (mounted) {
                setState(() {
                  this.isPlaying = isPlaying;
                });
              }
            }));

    final index = widget.currentIndex;
    super.initState();
  }

  IconData btnIcon = Icons.pause;
  IconData favIcon = Icons.favorite_border;
  Color colorFav = Colors.grey;

  //late String tracks = this.tracks;
  @override
  Widget build(BuildContext context) {
    List music = widget.musicList;

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
            height: 50,
          ),
          SizedBox(
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: QueryArtworkWidget(
                id: trackId == 0
                    ? widget.musicList[widget.currentIndex]['id']
                    : trackId,
                type: ArtworkType.AUDIO,
              ),
            ),
          ),
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
                        //currentSong,
                        trackTitle.length > 18
                            ? trackTitle.replaceRange(
                                18, trackTitle.length, '...')
                            : trackTitle,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Genera',
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        //currentArtist,
                        trackArtist.length > 20
                            ? trackArtist.replaceRange(
                                20, trackArtist.length, '...')
                            : trackArtist,
                        style: const TextStyle(
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
                      icon: isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border_outlined),
                      // icon: music[widget.currentIndex]['isFavorite'] == true
                      //     ? Icon(favIcon = Icons.favorite,
                      //         color: colorFav = Colors.red)
                      //     : Icon(favIcon, color: colorFav),
                      onPressed: () {
                        !isFavorite
                            ? setState(() {
                                isFavorite = true;

                                favIcon = Icons.favorite;
                                colorFav = Colors.red;
                                isFavorite = true;
                                favorite.add(music[widget.currentIndex]);

                                //print(favorite);
                                Hive.box('favorites').put(trackId, favorite[0]);
                                print(Hive.box('favorites').get(trackId));
                              })
                            : setState(() {
                                favIcon = Icons.favorite_border;
                                colorFav = Colors.grey;
                                isFavorite = false;
                                favorite.remove(music[widget.currentIndex]);
                                print(favorite);
                                Hive.box('favorites').delete(trackId);

                                //print(Hive.box('favorites').get('favorites'));
                                print(Hive.box('favorites').get('trackId'));
                              });
                      },
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // const Icon(Icons.playlist_add),
                  ],
                )
              ],
            ),
          ),
          //assetsAudioPlayer.builderRealtimePlayingInfos(builder: builder)

          // assetsAudioPlayer.builderRealtimePlayingInfos(
          //     builder: (context, RealtimePlayingInfos? infos) {
          //   print('Infos here: ${infos.toString()}');
          //   if (infos!.currentPosition == infos.duration) {
          //     // setState(() {
          //     //   widget.currentIndex = widget.currentIndex + 1;

          //     // });
          //     print('infos here: $infos');
          //     print(widget.currentIndex);
          //   }
          //   // setState(() {
          //   //               widget.currentIndex = widget.currentIndex + 1;
          //   //             });
          //   // }
          //   //print('infos: $infos');
          //   return Column(
          //     children: [
          //       // Padding(
          //       //   padding: const EdgeInsets.all(15.0),
          //       //   child: PositionSeekWidget(
          //       //     currentPosition: infos.currentPosition,
          //       //     duration: infos.duration,
          //       //     seekTo: (to) {
          //       //       assetsAudioPlayer.seek(to);
          //       //     },
          //       //   ),
          //       // ),
          //       //StreamBuilder<DurationState> ProgressBar(progress: progress, total: total)
          //       Padding(
          //         padding: const EdgeInsets.only(
          //             top: 30.0, bottom: 40.0, left: 30, right: 30),
          //         child: ProgressBar(
          //           progress: infos.currentPosition,
          //           total: infos.duration,
          //           onSeek: (to) {
          //             assetsAudioPlayer.seek(to);
          //             if (to == infos.duration) {
          //               setState(() {
          //                 widget.currentIndex = widget.currentIndex + 1;
          //               });
          //             }
          //           },
          //           progressBarColor: Colors.black,
          //           baseBarColor: Colors.grey[500],
          //           thumbColor: Colors.black,
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 25,
          //       ),
          //     ],
          //   );
          // }),
          // Padding(
          //         padding: const EdgeInsets.only(
          //             top: 30.0, bottom: 40.0, left: 30, right: 30),
          //         child: ProgressBar(
          //           progress: currentPosition,
          //           total: duration,
          //           onSeek: (to) {
          //             assetsAudioPlayer.seek(to);

          //           },
          //           progressBarColor: Colors.black,
          //           baseBarColor: Colors.grey[500],
          //           thumbColor: Colors.black,
          //         ),
          //       )
          audioPlayerSettings.infos(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  var snackBar =
                      const SnackBar(content: Text('No Previous Songs'));
                  setState(() {
                    widget.currentIndex == 0
                        ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
                        : widget.currentIndex--;
                    audioPlayerSettings.playPrevious();
                  });
                },
                icon: const Icon(Icons.skip_previous),
              ),
              const SizedBox(
                width: 12,
              ),
              IconButton(
                onPressed: () {
                  audioPlayerSettings.seekByBackward();
                },
                icon: const Icon(Icons.fast_rewind),
              ),
              const SizedBox(
                width: 12,
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black,
                child: IconButton(
                  iconSize: 35,
                  //icon: Icon(btnIcon, color: Colors.white),
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    audioPlayerSettings.playOrPauseAudio();
                  },
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              IconButton(
                onPressed: () {
                  audioPlayerSettings.seekByForward();
                },
                icon: const Icon(Icons.fast_forward),
              ),
              const SizedBox(
                width: 12,
              ),
              IconButton(
                  onPressed: () {
                    audioPlayerSettings.playNext();
                  },
                  icon: const Icon(Icons.skip_next)),
            ],
          )
        ],
      ),
    );
  }
}
