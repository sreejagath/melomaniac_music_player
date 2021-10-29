import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:hive/hive.dart';
import 'package:music_player/tabs/albumlist.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:on_audio_query/on_audio_query.dart';

// class Albums extends StatefulWidget {
//   const Albums({Key? key}) : super(key: key);

//   @override
//   _AlbumsState createState() => _AlbumsState();
// }

// class _AlbumsState extends State<Albums> {
//   List<String> trackTitle = [
//     'On My Way',
//     'Believer',
//     'Bad Liar',
//     'Shape of You',
//     'The Middle',
//     'The Greatest',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Container(
//           child: SingleChildScrollView(
//         child: Column(children: [
//           const SizedBox(
//             height: 15,
//           ),
//           InkWell(
//             onTap: () {
//               const HomePage();
//             },
//             child: Container(
//                 child: GridView(
//                     shrinkWrap: true,
//                     physics: const ScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 1.0,
//                             crossAxisSpacing: 10.0,
//                             mainAxisSpacing: 10.0),
//                     children: List.generate(
//                       trackTitle.length,
//                       (index) => _buildTrack(index),
//                     ))),
//           )
//         ]),
//       )),
//     );
//   }
// }

// _buildTrack(int index) {
//   List<String> trackTitle = [
//     'On My Way',
//     'Believer',
//     'Bad Liar',
//     'Shape of You',
//     'The Middle',
//     'The Greatest',
//   ];
//   List<String> trackArtist = [
//     'Ed Sheeran',
//     'Ed Sheeran',
//     'Ed Sheeran',
//     'Ed Sheeran',
//     'Ed Sheeran',
//     'Ed Sheeran',
//   ];

//   return Container(
//     child: Column(
//       children: [
//         Container(
//           width: 100.0,
//           height: 100.0,
//           decoration: const BoxDecoration(
//             //shape: BoxShape.circle,
//             image: DecorationImage(
//               fit: BoxFit.fill,
//               image: AssetImage('assets/images/image1.jpg'),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 10.0,
//         ),
//         Text(
//           trackTitle[index],
//           style: const TextStyle(
//             fontFamily: 'Khyay',
//             fontSize: 15.0,
//             color: Color(0xFF3A6878),
//           ),
//         ),
//         const SizedBox(
//           height: 5.0,
//         ),
//         Text(
//           trackArtist[index],
//           style: const TextStyle(
//             fontFamily: 'Khyay',
//             fontSize: 15.0,
//             color: Color(0xFF3A6878),
//           ),
//         ),
//         const Divider(
//           height: 5,
//         )
//       ],
//     ),
//   );
// }

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  List musics = [];
  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() async {
    var musicBox = await Hive.openBox('musicBox');
    setState(() {
      musics = musicBox.getAt(0);
    });
    print(musics);
  }

  @override
  Widget build(BuildContext context) {
    //String name = musics[0]['album'];
    return Container(
        child: SingleChildScrollView(
            child: Column(children: [
      const SizedBox(height: 15),
      GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: musics.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: InkResponse(
                child: Container(
                    child: Column(children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: QueryArtworkWidget(
                              id: musics[index]['id'],
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          musics[index]['album'].length > 10
                              ? musics[index]['album'].replaceRange(
                                  10, musics[index]['album'].length, '...')
                              : musics[index]['album'],
                          // style: const TextStyle(
                          //   fontFamily: 'Khyay',
                          //   fontSize: 15.0,
                          //   color: Color(0xFF3A6878),
                          // ),
                        ),
                      ],
                    ),
                  )
                ])),
                onTap: () {
                  List albumList = [];
                  for (var i = 0; i < musics.length; i++) {
                    if (musics[i]['album'] == musics[index]['album']) {
                      albumList.add(musics[i]);
                    }
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlbumList(
                                albumList: albumList,
                              )));
                }),
          );
        },
      )
    ])));
  }
}
