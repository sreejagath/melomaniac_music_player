import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
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

  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
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
            height: 100,
          ),
          SizedBox(
              height: 200,
              width: 200,
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
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Genera',
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        music[0]['artist'],
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
                      onPressed: () {
                        setState(() {
                          favIcon = Icons.favorite;
                          colorFav = Colors.red;
                        });
                      },
                      icon: Icon(favIcon, color: colorFav),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: PositionSeekWidget(
                    currentPosition: infos.currentPosition,
                    duration: infos.duration,
                    seekTo: (to) {
                      assetsAudioPlayer.seek(to);
                    },
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
                        assetsAudioPlayer.seekBy(const Duration(seconds: -10));
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
                        assetsAudioPlayer.seekBy(const Duration(seconds: -10));
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      onPressed: () {
                        assetsAudioPlayer.seekBy(const Duration(seconds: 10));
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
