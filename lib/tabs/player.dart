import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:music_player/getx/Controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/main.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class CurrentMusic extends StatefulWidget {
//   final List musicList;
//   int currentIndex;
//   CurrentMusic({
//     Key? key,
//     required this.musicList,
//     required this.currentIndex,
//   }) : super(key: key);

//   @override
//   _CurrentMusicState createState() => _CurrentMusicState();
// }

// class _CurrentMusicState extends State<CurrentMusic> {
//   Future<SharedPreferences> prefs = SharedPreferences.getInstance();
//   bool isPlaying = false;
//   String trackArtist = "";
//   String trackTitle = "";
//   int trackId = 0;
//   int track = 0;
//   List favorite = [];
//   List favorites = [];
//   bool? notifications;
//   List pathsForPlaying = [];
//   Duration? duration;
//   bool isFavorite = false;
//   final assetsAudioPlayer = AssetsAudioPlayer();

//   Future<bool> notification() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('notification') ?? true;
//   }

//   Future<bool> isfavorite() async {
//     final SharedPreferences fav = await SharedPreferences.getInstance();
//     fav.setBool('isFav', isFavorite);
//     return fav.getBool('isFav') ?? false;
//   }

//   setSongId() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setInt('id', widget.musicList[widget.currentIndex]['id']);
//     return prefs.getInt('id');
//   }

//   Future<int> getSongId() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('id')!;
//   }

//   var audiosForPlaying = <Audio>[];
//   Future<void> initializeAudiosForPlaying() async {
//     for (var i = 0; i < widget.musicList.length; i++) {
//       pathsForPlaying.add(widget.musicList[i]['uri']);
//     }
//     await Future.forEach(pathsForPlaying, (path) async {
//       audiosForPlaying.addAll(widget.musicList[widget.currentIndex]['uri']);
//     });
//   }

//   favoriteList() {
//     var favoriteList =
//         Hive.box('favorites').get(widget.musicList[widget.currentIndex]['id']);
//     if (favoriteList != null) {
//       isFavorite = true;
//     }
//   }

//   @override
//   void initState() {
//     favoriteList();
//     final List<Audio> audios = (widget.musicList)
//         .map((audio) => Audio.file(audio['uri'],
//             metas: Metas(
//                 title: audio['title'],
//                 artist: audio['artist'],
//                 id: audio['id'].toString(),
//                 extra: {'isFavorite': audio['isFavorite']})))
//         .toList();
//     audioPlayerSettings
//         .initializePlayer(
//       audios,
//       widget.currentIndex,
//     )
//         .then((value) {
//       audioPlayerSettings.currentValues.listen((current) {
//         if (mounted) {
//           if (current == null) {
//             return;
//           } else {
//             setState(() {
//               trackTitle = current.audio.audio.metas.title ?? 'No Title';
//               trackArtist = current.audio.audio.metas.artist ?? 'No Artist';
//               trackId = int.parse(current.audio.audio.metas.id!);
//               isFavorite = current.audio.audio.metas.extra!['isFavorite'];
//             });
//           }
//         }
//       });
//     }).then((value) =>
//             audioPlayerSettings.isAudioPlayerPlaying.listen((isPlaying) {
//               if (mounted) {
//                 setState(() {
//                   this.isPlaying = isPlaying;
//                 });
//               }
//             }));

//     final index = widget.currentIndex;
//     super.initState();
//   }

//   IconData btnIcon = Icons.pause;
//   IconData favIcon = Icons.favorite_border;
//   Color colorFav = Colors.grey;
//   @override
//   Widget build(BuildContext context) {
//     List music = widget.musicList;

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         title: const Text(
//           'Playing Now',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           ArtImage(trackId),
//           const SizedBox(
//             height: 20,
//           ),
//           trackDetails(trackTitle, trackArtist),
//           audioPlayerSettings.infos(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   var snackBar =
//                       const SnackBar(content: Text('No Previous Songs'));
//                   setState(() {
//                     widget.currentIndex == 0
//                         ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
//                         : widget.currentIndex--;
//                     audioPlayerSettings.playPrevious();
//                   });
//                 },
//                 icon: const Icon(Icons.skip_previous),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               IconButton(
//                 onPressed: () {
//                   audioPlayerSettings.seekByBackward();
//                 },
//                 icon: const Icon(Icons.fast_rewind),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.black,
//                 child: IconButton(
//                   iconSize: 35,
//                   icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                   onPressed: () {
//                     audioPlayerSettings.playOrPauseAudio();
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               IconButton(
//                 onPressed: () {
//                   audioPlayerSettings.seekByForward();
//                 },
//                 icon: const Icon(Icons.fast_forward),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               IconButton(
//                   onPressed: () {
//                     audioPlayerSettings.playNext();
//                   },
//                   icon: const Icon(Icons.skip_next)),
//             ],
//           )
//         ],
//       ),
//     );
//   }

// Widget ArtImage(trackId) {
//   return SizedBox(
//     height: 250,
//     width: 250,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(10.0),
//       child: QueryArtworkWidget(
//         id: trackId == 0
//             ? widget.musicList[widget.currentIndex]['id']
//             : trackId,
//         type: ArtworkType.AUDIO,
//         nullArtworkWidget: const Icon(
//           Icons.music_note,
//           size: 80,
//         ),
//       ),
//     ),
//   );
// }

//   Widget trackDetails(trackTitle, trackArtist) {
//     return Padding(
//       padding: const EdgeInsets.all(30.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   trackTitle.length > 22
//                       ? trackTitle.replaceRange(22, trackTitle.length, '...')
//                       : trackTitle,
//                   style: const TextStyle(color: Colors.black, fontSize: 20),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Text(
//                   trackArtist.length > 20
//                       ? trackArtist.replaceRange(20, trackArtist.length, '...')
//                       : trackArtist,
//                   style: const TextStyle(
//                     color: Colors.grey,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             width: 55,
//           ),
//         ],
//       ),
//     );
//   }
// }

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

class Player extends StatelessWidget {
  const Player({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argsController = Get.put(PlayerController());
    argsController.getData(Get.arguments);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Playing Now',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        //ArtImage(trackId),
        const SizedBox(
          height: 20,
        ),
        //trackDetails(trackTitle, trackArtist),
        audioPlayerSettings.infos(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                var snackBar =
                    const SnackBar(content: Text('No Previous Songs'));
                // setState(() {
                //   widget.currentIndex == 0
                //       ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
                //       : widget.currentIndex--;
                //   audioPlayerSettings.playPrevious();
                // });
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
      ]),
    );
  }
}
