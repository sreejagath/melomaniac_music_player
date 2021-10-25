import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/player/position_seek_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
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
  String currentSong = "";

  final assetsAudioPlayer = AssetsAudioPlayer();
  List playlist = [];
  bool? notifications;

  Future<bool> notification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification') ?? true;
  }

  @override
  void initState() {
    final audios = widget.musicList;
    super.initState();
    isPlaying = true;
    notification().then((value) {
      notifications = value;
    });
    assetsAudioPlayer.open(
      Playlist(
        audios: audios
            .map((audio) => Audio.file(
                  audio['uri'],
                  metas: Metas(
                    title: audio['title'],
                    artist: audio['artist'],
                    //album: "CountryAlbum",
                    // image: MetasImage.asset(
                    //     widget.musicList[0]['id']), //can be MetasImage.network
                  ),
                ))
            .toList(),
        startIndex: widget.currentIndex,
      ),
      showNotification: notifications??true,
      autoStart: true,
    );
    var favoritesBox = Hive.openBox('favorites');
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  //@override
  //print(favs);
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
                id: music[widget.currentIndex]['id'],
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
                        music[widget.currentIndex]['title'].length > 18
                            ? music[widget.currentIndex]['title'].replaceRange(
                                18,
                                music[widget.currentIndex]['title'].length,
                                '...')
                            : music[widget.currentIndex]['title'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Genera',
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        music[widget.currentIndex]['artist'].length > 20
                            ? music[widget.currentIndex]['artist'].replaceRange(
                                20,
                                music[widget.currentIndex]['artist'].length,
                                '...')
                            : music[widget.currentIndex]['artist'],
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
                      icon: music[widget.currentIndex]['isFavorite'] == true
                          ? Icon(favIcon = Icons.favorite,
                              color: colorFav = Colors.red)
                          : Icon(favIcon, color: colorFav),
                      onPressed: () {
                        music[widget.currentIndex]['isFavorite'] == false
                            ? setState(() {
                                favIcon = Icons.favorite;
                                colorFav = Colors.red;
                                music[widget.currentIndex]['isFavorite'] = true;
                                if (music[widget.currentIndex]['isFavorite'] ==
                                    true) {
                                  playlist.add(music[widget.currentIndex]);
                                  //Hive.box('favorites').addAll(playlist);
                                  //print(playlist);
                                  Hive.box('musicBox')
                                      .put(widget.currentIndex, playlist);
                                }
                              })
                            : setState(() {
                                favIcon = Icons.favorite_border;
                                colorFav = Colors.grey;
                                music[widget.currentIndex]['isFavorite'] =
                                    false;
                                if (music[widget.currentIndex]['isFavorite'] ==
                                    false) {
                                  playlist.remove(music[widget.currentIndex]);
                                  // Hive.box('musicBox')
                                  //     .put(widget.currentIndex, playlist);
                                }
                              });
                      },
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
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, RealtimePlayingInfos? infos) {
            if (infos == null) {
              return const SizedBox();
            }
            //print('infos: $infos');
            return Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(15.0),
                //   child: PositionSeekWidget(
                //     currentPosition: infos.currentPosition,
                //     duration: infos.duration,
                //     seekTo: (to) {
                //       assetsAudioPlayer.seek(to);
                //     },
                //   ),
                // ),
                //StreamBuilder<DurationState> ProgressBar(progress: progress, total: total)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 40.0, left: 30, right: 30),
                  child: ProgressBar(
                    progress: infos.currentPosition,
                    total: infos.duration,
                    onSeek: (to) {
                      assetsAudioPlayer.seek(to);
                      if (to == infos.duration) {
                        setState(() {
                          widget.currentIndex = widget.currentIndex + 1;
                        });
                      }
                    },
                    progressBarColor: Colors.black,
                    baseBarColor: Colors.grey[500],
                    thumbColor: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        var snackBar =
                            const SnackBar(content: Text('No Previous Songs'));
                        setState(() {
                          widget.currentIndex == 0
                              ? ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar)
                              : widget.currentIndex--;
                          assetsAudioPlayer.previous(keepLoopMode: false);
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(const Duration(seconds: -10));
                      },
                      icon: const Icon(Icons.skip_previous),
                    ),
                    const SizedBox(
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
                    const SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(const Duration(seconds: 10));
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        var snackBar = SnackBar(content: Text('No Next Songs'));
                        setState(() {
                          widget.currentIndex == widget.musicList.length - 1
                              ? widget.currentIndex = 0
                              : widget.currentIndex++;
                          assetsAudioPlayer.next(keepLoopMode: true);
                        });
                        print('Current Index\n\n\n');
                        print(widget.currentIndex);
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
