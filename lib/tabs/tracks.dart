import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:music_player/db_model/data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Tracks extends StatefulWidget {
  const Tracks({Key? key}) : super(key: key);

  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List music = [
    {
      'title': 'Malare',
      'artist': 'Rajesh Murugeshan',
      'uri': 'assets/music/song.mp3',
      'id': 'assets/images/malare.jpg',
      'asset': 'true'
    },
  ];
  List musics = [];

  @override
  void initState() {
    super.initState();
    musicListing();
  }

  musicListing() async {
    var musicBox = await Hive.openBox('musicBox');
    setState(() {
      musics = musicBox.get(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    //List mu = music[0].toList();
    //final _tracks = music;
    return musics==null ? Center(child: CircularProgressIndicator()) :
    ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: music.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(music[index]['id']),
                  ),
                  title: Text(
                    music[index]['title'],
                    style: const TextStyle(
                      fontFamily: 'Genera',
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    music[index]['artist'],
                    style: const TextStyle(
                      fontFamily: 'Genera',
                      fontSize: 15.0,
                      color: Color(0xFF3A6878),
                    ),
                  ),
                  trailing: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      itemBuilder: (context) => [
                            const PopupMenuItem(child: Text('Add to queue')),
                            const PopupMenuItem(child: Text('Add to playlist')),
                            PopupMenuItem(
                              child: const Text('Song Info'),
                              value: 3,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          content: Column(
                                            children: [
                                              Image.asset(
                                                'assets/images/image1.jpg',
                                                width: 100,
                                                height: 100,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                    'Title : On My Way',
                                                    style: TextStyle(
                                                        fontFamily: 'Genera',
                                                        fontSize: 20.0,
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    'Artist : Ed Sheeran',
                                                    style: TextStyle(
                                                        fontFamily: 'Genera',
                                                        fontSize: 15.0,
                                                        color:
                                                            Color(0xFF3A6878)),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text('Artist : Ed Sheeran',
                                                      style: TextStyle(
                                                          fontFamily: 'Genera',
                                                          fontSize: 15.0,
                                                          color: Color(
                                                              0xFF3A6878))),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Text('Year : 2019',
                                                      style: TextStyle(
                                                          fontFamily: 'Genera',
                                                          fontSize: 15.0,
                                                          color: Color(
                                                              0xFF3A6878))),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                child:
                                                    const Text('Search Lyrics'),
                                              ),
                                            ],
                                          ));
                                    });
                              },
                            ),
                            const PopupMenuItem(child: Text('View Album')),
                            const PopupMenuItem(child: Text('Share')),
                          ]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CurrentMusic(
                                  musicList: music,
                                )));
                  },
                ),
                const Divider(
                  color: Colors.black,
                  height: 10,
                ),
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: musics.length,
                    itemBuilder: (BuildContext context, int index) {
                      List data = [
                        {
                          'title': musics[index]['title'],
                          'artist': musics[index]['artist'],
                          'uri': musics[index]['uri'],
                          'id': musics[index]['id'],
                          'asset': 'false'
                        }
                      ];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              musics[index]['title'],
                              style: const TextStyle(
                                fontFamily: 'Genera',
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              musics[index]['artist'] ?? "No Artist",
                              style: const TextStyle(
                                fontFamily: 'Genera',
                                fontSize: 15.0,
                                color: Color(0xFF3A6878),
                              ),
                            ),
                            leading: QueryArtworkWidget(
                              id: musics[index]['id'],
                              type: ArtworkType.AUDIO,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CurrentMusic(musicList: data)));
                            },
                          )
                        ],
                      );
                    })
                // FutureBuilder<List<SongModel>>(
                //   // Default values:
                //   future: _audioQuery.querySongs(
                //     sortType: null,
                //     orderType: OrderType.ASC_OR_SMALLER,
                //     uriType: UriType.EXTERNAL,
                //     ignoreCase: true,
                //   ),
                //   builder: (context, item) {
                //     // Loading content
                //     if (item.data == null)
                //       return const CircularProgressIndicator();
                //     if (item.data!.isEmpty) return const Text("Nothing found!");
                //     return ListView.builder(
                //       scrollDirection: Axis.vertical,
                //       shrinkWrap: true,
                //       itemCount: item.data!.length,
                //       itemBuilder: (context, index) {
                //         print('from list builder');
                //         print(item.data!);
                //         print('end od ');
                //         List data = [
                //           {
                //             'title': item.data![index].title,
                //             'artist': item.data![index].artist,
                //             'uri': item.data![index].uri,
                //             'id': item.data![index].id,
                //             'asset': 'false'
                //           }
                //         ];
                //         return SingleChildScrollView(
                //           child: Column(
                //             children: [
                //               ListTile(
                //                   title: Text(
                //                     item.data![index].title,
                //                     style: const TextStyle(
                //                       fontFamily: 'Genera',
                //                       fontSize: 15.0,
                //                       color: Colors.black,
                //                     ),
                //                   ),
                //
                //                   trailing: PopupMenuButton(
                //                       shape: RoundedRectangleBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(10.0)),
                //                       itemBuilder: (context) => [
                //                             const PopupMenuItem(
                //                                 child: Text('Add to queue')),
                //                             const PopupMenuItem(
                //                                 child: Text('Add to playlist')),
                //                             PopupMenuItem(
                //                               child: const Text('Song Info'),
                //                               value: 3,
                //                               onTap: () {
                //                                 print('hello');
                //                                 showDialog(
                //                                     context: context,
                //                                     builder: (context) {
                //                                       return AlertDialog(
                //                                           shape: const RoundedRectangleBorder(
                //                                               borderRadius: BorderRadius
                //                                                   .all(Radius
                //                                                       .circular(
                //                                                           10.0))),
                //                                           content: Column(
                //                                             children: [
                //                                               Image.asset(
                //                                                 'assets/images/image1.jpg',
                //                                                 width: 100,
                //                                                 height: 100,
                //                                               ),
                //                                               const SizedBox(
                //                                                 height: 30,
                //                                               ),
                //                                               Column(
                //                                                 crossAxisAlignment:
                //                                                     CrossAxisAlignment
                //                                                         .start,
                //                                                 children: const [
                //                                                   Text(
                //                                                     'Title : On My Way',
                //                                                     style: TextStyle(
                //                                                         fontFamily:
                //                                                             'Genera',
                //                                                         fontSize:
                //                                                             20.0,
                //                                                         color: Colors
                //                                                             .black),
                //                                                   ),
                //                                                   SizedBox(
                //                                                     height: 30,
                //                                                   ),
                //                                                   Text(
                //                                                     'Artist : Ed Sheeran',
                //                                                     style: TextStyle(
                //                                                         fontFamily:
                //                                                             'Genera',
                //                                                         fontSize:
                //                                                             15.0,
                //                                                         color: Color(
                //                                                             0xFF3A6878)),
                //                                                   ),
                //                                                   SizedBox(
                //                                                     height: 30,
                //                                                   ),
                //                                                   Text(
                //                                                       'Artist : Ed Sheeran',
                //                                                       style: TextStyle(
                //                                                           fontFamily:
                //                                                               'Genera',
                //                                                           fontSize:
                //                                                               15.0,
                //                                                           color:
                //                                                               Color(0xFF3A6878))),
                //                                                   SizedBox(
                //                                                     height: 30,
                //                                                   ),
                //                                                   Text(
                //                                                       'Year : 2019',
                //                                                       style: TextStyle(
                //                                                           fontFamily:
                //                                                               'Genera',
                //                                                           fontSize:
                //                                                               15.0,
                //                                                           color:
                //                                                               Color(0xFF3A6878))),
                //                                                 ],
                //                                               ),
                //                                               const SizedBox(
                //                                                 height: 30,
                //                                               ),
                //                                               ElevatedButton(
                //                                                 onPressed:
                //                                                     () {},
                //                                                 child: const Text(
                //                                                     'Search Lyrics'),
                //                                               ),
                //                                             ],
                //                                           ));
                //                                     });
                //                               },
                //                             ),
                //                             const PopupMenuItem(
                //                                 child: Text('View Album')),
                //                             const PopupMenuItem(
                //                                 child: Text('Share')),
                //                           ]),

                //                   //onTap: openPage(data),
                //                   onTap: () async {
                //                     Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                             builder: (BuildContext context) =>
                //                                 CurrentMusic(musicList: data)));
                //                     print(data);
                //                   }),
                //               const Divider(
                //                 color: Colors.black,
                //                 height: 10,
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  openPage(List audio) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CurrentMusic(musicList: music)));
  }
}
