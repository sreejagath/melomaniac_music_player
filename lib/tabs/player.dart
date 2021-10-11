import 'package:flutter/material.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:audioplayers/audioplayers.dart';

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
  AudioCache audioCache =
      AudioCache(prefix: 'assets/music/', fixedPlayer: AudioPlayer());
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  @override
  void initState() {
    super.initState();
    audioCache.play('song.mp3');
    isPlaying = true;
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
            height: 50,
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
                        onPressed: () {},
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                const Text('00:00'),
                Expanded(
                  child: SliderTheme(
                      data: const SliderThemeData(
                        thumbColor: Colors.black,
                        inactiveTrackColor: Colors.grey,
                      ),
                      child: Slider(value: 0, onChanged: (value) {})),
                ),
                const Text('03:40')
              ],
            ),
          ),
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
                    audioPlayer.resume();
                    setState(() {
                      isPlaying = true;
                      btnIcon = Icons.pause;
                    });
                  }
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
