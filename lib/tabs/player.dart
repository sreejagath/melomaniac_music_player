import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/player/position_seek_widget.dart';
import 'package:music_player/settings/player_settings.dart';
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
  String currentArtist = "";
  String currentArtUri = "";

  final assetsAudioPlayer = AssetsAudioPlayer();
  List playlist = [];
  bool? notifications;
  List pathsForPlaying = [];

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
      audiosForPlaying.add(await Audio.file(path.toString()));
    });
  }

  // play() async {
  //   await initializeAudiosForPlaying();
  //   print(audiosForPlaying);
  //   await assetsAudioPlayer.open(
  //     Playlist(audios:audiosForPlaying,
  //     startIndex: widget.currentIndex,),
  //     showNotification: true,

  //     );
  //   //audioPlayerSettings.initializeAudioPlayerWithAudios(audiosForPlaying);
  // }

  final audioPlayerSettings = AudioPlayerSettings();
  @override
  void initState() {
    print('id here ${widget.musicList[widget.currentIndex]['id']}');
    final audios = widget.musicList;
    final index = widget.currentIndex;
    //playlist = audios;
    notification().then((value) {
      print(value);
      notifications = value;
    });
    super.initState();
    setSongId().then((value) {
      print('id here $value');
    });
    //isPlaying = true;
    //songPlaying();
    getSongId().then((value) {
      print('value : $value');
      if (value == widget.musicList[widget.currentIndex]['id']) {
        //audioPlayerSettings.stopSongs();
        //print('song id: $value');
        //assetsAudioPlayer.pause();
        //assetsAudioPlayer.dispose();
        //assetsAudioPlayer.playlistPlayAtIndex(widget.currentIndex);
        assetsAudioPlayer.stop();
        assetsAudioPlayer.open(
          Playlist(
            audios: audios
                .map((audio) => Audio.file(
                      audio['uri'],
                      metas: Metas(
                        title: audio['title'],
                        artist: audio['artist'],
                        id: audio['id'].toString(),
                        //image: audio['id'],
                      ),
                    ))
                .toList(),
            startIndex: widget.currentIndex,
          ),
          showNotification: notifications ?? false,
          autoStart: true,
          loopMode: LoopMode.playlist,
          playInBackground: PlayInBackground.enabled,
        );
      }
    });

    // assetsAudioPlayer.isPlaying.listen((isPlaying) {
    //   if (isPlaying) {
    //     setState(() {
    //       print('isPlaying : $isPlaying');
    //       this.isPlaying = isPlaying;
    //     });
    //   assetsAudioPlayer.current.listen((event) {
    //     getSongId().then((value) {
    //       print('value : $value');
    //       if (value != widget.musicList[widget.currentIndex]['id']) {
    //         assetsAudioPlayer.stop();
    //         setState(() {
    //           assetsAudioPlayer.open(
    //             Playlist(
    //               audios: audios
    //                   .map((audio) => Audio.file(
    //                         audio['uri'],
    //                         metas: Metas(
    //                           title: audio['title'],
    //                           artist: audio['artist'],
    //                           id: audio['id'].toString(),
    //                           //image: audio['id'],
    //                         ),
    //                       ))
    //                   .toList(),
    //               startIndex: widget.currentIndex,
    //             ),
    //             showNotification: notifications ?? false,
    //             autoStart: true,
    //             loopMode: LoopMode.playlist,
    //             playInBackground: PlayInBackground.enabled,
    //           );
    //         });
    //       }
    //     });
    //   });
    // } else {
    //   print(isPlaying);
    //   setSongId().then((value) {
    //     print('id here $value');

    //     assetsAudioPlayer.open(
    //       Playlist(
    //         audios: audios
    //             .map((audio) => Audio.file(
    //                   audio['uri'],
    //                   metas: Metas(
    //                     title: audio['title'],
    //                     artist: audio['artist'],
    //                     id: audio['id'].toString(),
    //                     //image: audio['id'],
    //                   ),
    //                 ))
    //             .toList(),
    //         startIndex: widget.currentIndex,
    //       ),
    //       showNotification: notifications ?? false,
    //       autoStart: true,
    //       loopMode: LoopMode.playlist,
    //       playInBackground: PlayInBackground.enabled,
    //     );

    // setState(() {
    //   print('isPlaying : $isPlaying');
    //   this.isPlaying = isPlaying;
    // });
    //   });
    //   }
    // });

    assetsAudioPlayer.current.listen((event) {
      //find id of playing
      //print('Event audio here: ${event?.audio.audio.metas.id}');
      // if (event?.audio.audio.metas.id !=
      //     widget.musicList[widget.currentIndex]['id']) {
      //   print('Event audio here: ${event?.audio.audio.metas.id}');
      //   setState(() {
      //     assetsAudioPlayer.pause();
      //   });
      // }
      String? name = event?.audio.audio.metas.title;
      String? artist = event?.audio.audio.metas.artist;
      String? artUri = event?.audio.audio.metas.image.toString();
      if (name != null && artist != null) {
        currentSong = name;
        currentArtist = artist;
        currentArtUri = artUri!;
        //print(artUri); //
        setState(() {});
      }

      // event?.audio.audio.metas.title.then((title) {
      //   setState(() {
      //     currentSong = title;
      //   });
      // });
    });
    //play();

    var favoritesBox = Hive.openBox('favorites');

    //updation();
    //var current = assetsAudioPlayer.currentPosition;
    // assetsAudioPlayer.currentPosition.listen((position) {
    //   if (position.inSeconds == assetsAudioPlayer.current.duration.inSeconds) {
    //     if (assetsAudioPlayer.currentIndex ==
    //         assetsAudioPlayer.playlist.audios.length - 1) {
    //       assetsAudioPlayer.playlist.next();
    //     } else {
    //       assetsAudioPlayer.playlist.next();
    //     }
    //   }
    // });
  }

//IMPORTANT
  // void updation() {
  //   assetsAudioPlayer.currentPosition.listen((position) {
  //     assetsAudioPlayer.current.listen((event) {
  //       print((event?.audio.duration.inMilliseconds).toString());
  //       print((position.inMilliseconds).toString());
  //       print('Duration');
  //       if (event?.audio.duration.inMilliseconds == position.inMilliseconds) {
  //         setState(() {
  //           widget.currentIndex = widget.currentIndex + 1;
  //         });
  //       }
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   assetsAudioPlayer.dispose();
  //   super.dispose();
  // }

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
                        //currentSong,
                        currentSong.length > 18
                            ? currentSong.replaceRange(
                                18, currentSong.length, '...')
                            : currentSong,
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
                        currentArtist.length > 20
                            ? currentArtist.replaceRange(
                                20, currentArtist.length, '...')
                            : currentArtist,
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
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // const Icon(Icons.playlist_add),
                  ],
                )
              ],
            ),
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, RealtimePlayingInfos? infos) {
            if (infos!.currentPosition == infos.duration) {
              // setState(() {
              //   widget.currentIndex = widget.currentIndex + 1;

              // });
              print(widget.currentIndex);
            }
            // setState(() {
            //               widget.currentIndex = widget.currentIndex + 1;
            //             });
            // }
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
                            assetsAudioPlayer.playOrPause();
                            setState(() {
                              btnIcon = Icons.play_arrow;
                            });
                          } else {
                            assetsAudioPlayer.playOrPause();
                            setState(() {
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
                        print('Index : ${widget.currentIndex}');
                        //var snackBar = SnackBar(content: Text('No Next Songs'));
                        setState(() {
                          widget.currentIndex == widget.musicList.length - 1
                              ? setState(() {
                                  assetsAudioPlayer.stop();
                                  widget.currentIndex = 0;
                                  assetsAudioPlayer
                                      .playlistPlayAtIndex(widget.currentIndex);
                                })
                              : setState(() {
                                  assetsAudioPlayer.stop();
                                  widget.currentIndex++;
                                  // assetsAudioPlayer
                                  //     .playlistPlayAtIndex(widget.currentIndex);
                                  assetsAudioPlayer.next();
                                });
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
