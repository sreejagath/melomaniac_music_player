// ignore_for_file: avoid_print

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/db_model/playlist_model.dart';
import 'package:music_player/tabs/player.dart';
import 'package:music_player/tabs/tracklist.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List musics = [];
  List playlists = [];
  List playlistData = [];
  List favoritesList = [];
  @override
  void initState() {
    super.initState();
    musicSearch();
  }

  musicSearch() async {
    var musicBox = await Hive.openBox('musicBox');
    var playlistBox = await Hive.openBox('playlistBox');
    var favoritesBox = await Hive.openBox('favorites');
    setState(() {
      musics = musicBox.get(0);
      for (var i = 0; i < playlistBox.length; i++) {
        playlistData.add(playlistBox.getAt(i));
      }
      for (var i = 0; i < musics.length; i++) {
        if (musics[i]['isFavorite'] == true) {
          //print(musics[i]['title']);
          favoritesList.add(musics[i]);
          print(favoritesList);
        }
      }
      //print(musics[0]);
    });
    //print(playlistData);
    //for (var i = 0; i < musics.length; i++) {
    //print(musics);
    //}
  }

  List<String> trackTitle = [
    'On My Way',
    'Thunder',
    'Alone',
    'Despacito',
    'Shape of You',
    'Perfect',
    'Havana',
    'See You Again',
    'Despacito',
    'Shape of You',
  ];

  List<String> trackArtist = [
    'Ed Sheeran',
    'Taylor Swift',
    'Justin Bieber',
    'Luis Fonsi',
    'Shawn Mendes',
    'Ed Sheeran',
    'Taylor Swift',
    'Justin Bieber',
    'Luis Fonsi',
    'Shawn Mendes',
  ];

  List<String> timeList = [
    '03:30',
    '04:30',
    '05:30',
    '06:30',
    '07:30',
    '08:30',
    '09:30',
    '10:30',
    '11:30',
    '12:30',
  ];

  List music = [
    {
      'title': 'Malare',
      'artist': 'Rajesh Murugan',
      'url': 'assets/music/song.mp3'
    }
  ];
  @override
  Widget build(BuildContext context) {
    TextEditingController _playlist = TextEditingController();
    int _len = musics.length;
    List<bool> isChecked = List.generate(_len, (index) => false);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(children: [
              TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add to Playlist'),
                          content: TextField(
                            controller: _playlist,
                            decoration: InputDecoration(
                              hintText: 'Playlist Name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Add'),
                              onPressed: () async {
                                var playlistBox =
                                    await Hive.openBox('playlistBox');
                                setState(() {
                                  playlists = [
                                    {'playlist': _playlist.text, 'tracks': []}
                                  ];
                                  playlistBox.add(playlists[0]);
                                  playlistData.add(playlistBox
                                      .getAt(playlistBox.length - 1));

                                  //reassemble();
                                });
                                String playlistName = _playlist.text;
                                final snackBar = SnackBar(
                                  content: Text(
                                      'Created  Playlist $playlistName Successfully !\nPlease add song manually !\nTracks > Options > Add to playlist'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text('New Playlist')
                  ],
                ),
              ),
            ]),
          ),

          //           child: Row(
          //             children: [
          //               TextButton(
          //                 onPressed: () {
          //                   showModalBottomSheet(
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.all(
          //                               Radius.circular(10.0))),
          //                       context: context,
          //                       builder: (context) {
          //                         return Container(
          //                           height: MediaQuery.of(context).size.height *
          //                               0.5,
          //                           child: Form(
          //                               child: Column(
          //                             children: [
          //                               SizedBox(
          //                                 height: 20,
          //                               ),
          //                               Padding(
          //                                 padding: const EdgeInsets.only(left: 15,right:15),
          //                                 child: TextFormField(
          //                                   //controller: _filter,
          //                                   decoration: new InputDecoration(
          //                                       prefixIcon: new Icon(Icons.add),
          //                                       hintText: 'New Playlist'),
          //                                 ),
          //                               ),
          //                               SizedBox(height: 2,),
          //                               ElevatedButton(onPressed: (){}, child: Text('Create')),
          //                             ],
          //                           )),
          //                         );
          //                       });
          //                 },
          //                 child: Row(
          //                   children: const [
          //                     Icon(Icons.add),
          //                     SizedBox(
          //                       width: 10.0,
          //                     ),
          //                     Text('New Playlist')
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ))
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 15,
          ),
          // GestureDetector(
          //   onTap: () async {
          //     showModalBottomSheet(
          //         context: context,
          //         builder: (context) {
          //           return Container(
          //             height: MediaQuery.of(context).size.height * 0.5,
          //             child: ListView.builder(
          //               itemCount: trackTitle.length,
          //               itemBuilder: (context, index) {
          //                 return ListTile(
          //                   leading: Icon(Icons.music_note),
          //                   title: TextButton(
          //                     style: TextButton.styleFrom(
          //                         alignment: Alignment.centerLeft),
          //                     child: Text(trackTitle[index]),
          //                     onPressed: () {
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => CurrentMusic(
          //                                     musicList: music,
          //                                     currentIndex: index,
          //                                   )));
          //                     },
          //                   ),
          //                   subtitle: Text(trackArtist[index]),
          //                   trailing: PopupMenuButton(
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(10.0)),
          //                       itemBuilder: (context) => [
          //                             const PopupMenuItem(
          //                                 child: Text('Add to queue')),
          //                             const PopupMenuItem(
          //                                 child: Text('Add to playlist')),
          //                             PopupMenuItem(
          //                                 child: TextButton(
          //                               onPressed: () {
          //                                 showDialog(
          //                                     context: context,
          //                                     builder: (context) => AlertDialog(
          //                                         shape:
          //                                             const RoundedRectangleBorder(
          //                                                 borderRadius:
          //                                                     BorderRadius.all(
          //                                                         Radius.circular(
          //                                                             10.0))),
          //                                         content: Column(
          //                                           children: [
          //                                             Image.asset(
          //                                               'assets/images/image1.jpg',
          //                                               width: 100,
          //                                               height: 100,
          //                                             ),
          //                                             const SizedBox(
          //                                               height: 30,
          //                                             ),
          //                                             Column(
          //                                               crossAxisAlignment:
          //                                                   CrossAxisAlignment
          //                                                       .start,
          //                                               children: const [
          //                                                 Text(
          //                                                   'Title : On My Way',
          //                                                   style: TextStyle(
          //                                                       fontFamily:
          //                                                           'Genera',
          //                                                       fontSize: 20.0,
          //                                                       color: Colors
          //                                                           .black),
          //                                                 ),
          //                                                 SizedBox(
          //                                                   height: 30,
          //                                                 ),
          //                                                 Text(
          //                                                   'Artist : Ed Sheeran',
          //                                                   style: TextStyle(
          //                                                       fontFamily:
          //                                                           'Genera',
          //                                                       fontSize: 15.0,
          //                                                       color: Color(
          //                                                           0xFF3A6878)),
          //                                                 ),
          //                                                 SizedBox(
          //                                                   height: 30,
          //                                                 ),
          //                                                 Text(
          //                                                     'Artist : Ed Sheeran',
          //                                                     style: TextStyle(
          //                                                         fontFamily:
          //                                                             'Genera',
          //                                                         fontSize:
          //                                                             15.0,
          //                                                         color: Color(
          //                                                             0xFF3A6878))),
          //                                                 SizedBox(
          //                                                   height: 30,
          //                                                 ),
          //                                                 Text('Year : 2019',
          //                                                     style: TextStyle(
          //                                                         fontFamily:
          //                                                             'Genera',
          //                                                         fontSize:
          //                                                             15.0,
          //                                                         color: Color(
          //                                                             0xFF3A6878))),
          //                                               ],
          //                                             ),
          //                                             const SizedBox(
          //                                               height: 30,
          //                                             ),
          //                                             ElevatedButton(
          //                                               onPressed: () {},
          //                                               child: const Text(
          //                                                   'Search Lyrics'),
          //                                             ),
          //                                           ],
          //                                         )));
          //                               },
          //                               child: const Text(
          //                                 'Song Info',
          //                                 textAlign: TextAlign.left,
          //                                 style: TextStyle(color: Colors.black),
          //                               ),
          //                             )),
          //                             const PopupMenuItem(
          //                                 child: Text('View Album')),
          //                             const PopupMenuItem(child: Text('Share')),
          //                           ]),
          //                 );
          //               },
          //             ),
          //           );
          //         });
          //   },
          Column(
            children: [
              ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  onTap: () async {
                    var favBox = await Hive.openBox('favorites');

                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          print(favoritesList.length);
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: favoritesList.isEmpty
                                ? ListTile(
                                    leading: Icon(Icons.favorite_border),
                                    title: Text('No Favorites'),
                                    subtitle:
                                        Text('Add some songs to favorites'),
                                  )
                                : ListView.builder(
                                    itemCount: favoritesList.length,
                                    itemBuilder: (context, index) {
                                      // print('from clicking favorites');
                                      // print(favBox.getAt(index)['title']);
                                      //print(favBox.getAt(0));
                                      print('end');
                                      return ListTile(
                                        leading: Icon(Icons.music_note),
                                        title:
                                            Text(favoritesList[index]['title']),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CurrentMusic(
                                                        musicList:
                                                            favoritesList,
                                                        currentIndex: index,
                                                      )));
                                        },
                                        subtitle: Text(
                                            favoritesList[index]['artist']),
                                        trailing: PopupMenuButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                      child:
                                                          Text('Add to queue')),
                                                  const PopupMenuItem(
                                                      child: Text(
                                                          'Add to playlist')),
                                                  PopupMenuItem(
                                                      child: TextButton(
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Song Info',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )),
                                                  const PopupMenuItem(
                                                      child:
                                                          Text('View Album')),
                                                  const PopupMenuItem(
                                                      child: Text('Share')),
                                                ]),
                                      );
                                    },
                                  ),
                          );
                        });
                  }),
              ListView.builder(
                itemCount: playlistData.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  print(playlistData[index]['playlist']);
                  return ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.black),
                    title: Text(
                      //'Hello',
                      playlistData[index]['playlist'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: 'Genera'),
                    ),
                    subtitle: Text(
                      playlistData[index]['tracks'].length.toString() +
                      ' Songs',
                      style: const TextStyle(fontFamily: 'Genera'),
                    ),
                    onTap: () async {
                      var favBox = await Hive.openBox('favorites');
                      var playlistBox = await Hive.openBox('playlistBox');
                      // print(playlistBox.getAt(0)['tracks'][1]['title']);
                      // var first = playlistBox.getAt(1)['tracks'][0]['title'];
                      // print(first);
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: playlistData[index]['tracks'].isEmpty
                                  ? ListTile(
                                      leading: Icon(Icons.music_note),
                                      title: Text('No Songs'),
                                      subtitle: Text(
                                          'Please add song manually !\nTracks > Options > Add to playlist'),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          playlistData[index]['tracks'].length,
                                      itemBuilder: (context, values) {
                                        // print('from clicking favorites');
                                        // print(favBox.getAt(index)['title']);
                                        print(playlistData[index]['tracks']
                                            [values]['title']);
                                        //print('end');
                                        return ListTile(
                                          leading: Icon(Icons.music_note),
                                          title: Text(playlistData[index]
                                              ['tracks'][values]['title']),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CurrentMusic(
                                                          musicList:
                                                              playlistData[
                                                                      index]
                                                                  ['tracks'],
                                                          currentIndex: values,
                                                        )));
                                          },
                                          subtitle: Text(playlistData[index]
                                              ['tracks'][values]['artist']),
                                          trailing: PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              itemBuilder: (context) => [
                                                    const PopupMenuItem(
                                                        child: Text(
                                                            'Remove from Playlist')),
                                                    PopupMenuItem(
                                                        child: TextButton(
                                                      onPressed: () {},
                                                      child: const Text(
                                                        'Song Info',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    )),
                                                    const PopupMenuItem(
                                                        child:
                                                            Text('View Album')),
                                                    const PopupMenuItem(
                                                        child: Text('Share')),
                                                  ]),
                                        );
                                      },
                                    ),
                            );
                          });
                    },
                    trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: TextButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Confirmation'),
                                    content:
                                        const Text('Are you sure to Delete ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          var playlistBox =
                                              await Hive.openBox('playlistBox');
                                          playlistBox.deleteAt(index);

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {
                                            playlistData.removeAt(index);
                                          });
                                        },
                                        child: const Text('OK'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const Text('Delete Playlist',
                                    style: TextStyle(color: Colors.red)),
                              )),
                              PopupMenuItem(
                                  child: TextButton(
                                      child: const Text(
                                        'Rename',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Form(
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                          labelText:
                                                              'Current Name',
                                                        ))
                                                      ]),
                                                ),
                                                title: const Text('Rename'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: const Text('OK'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            });
                                      })),
                            ]),
                  );
                },
              ),
            ],
          ),
          //  ),
        ],
      ),
    );
  }
//}
}
