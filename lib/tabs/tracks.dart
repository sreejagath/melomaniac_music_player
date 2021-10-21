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
  List playlists = [];

  @override
  void initState() {
    super.initState();
    musicListing();
  }

  musicListing() async {
    var musicBox = await Hive.openBox('musicBox');
    var playlistBox = await Hive.openBox('playlistBox');
    setState(() {
      musics = musicBox.get(0);
      for (var i = 0; i < playlistBox.length; i++) {
        playlists.add(playlistBox.getAt(i));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //List mu = music[0].toList();
    //final _tracks = music;
    return musics == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: musics.length,
            itemBuilder: (BuildContext context, int index) {
              print(musics);
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
                    trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        itemBuilder: (context) => [
                              //const PopupMenuItem(child: Text('Add to queue')),
                              PopupMenuItem(
                                  child: TextButton(
                                child: Text('Add to playlist'),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Add to Playlist'),
                                          content: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            width: double.maxFinite,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: playlists.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    title: Text(playlists[index]
                                                        ['playlist']),
                                                    onTap: () async {
                                                      var playlistBox =
                                                          await Hive.openBox(
                                                              'playlistBox');
                                                      playlists[index]['tracks']
                                                          .add(data);
                                                      setState(() {
                                                        playlistBox.put(index,
                                                            playlists[index]);
                                                      });
                                                      String trackName =
                                                          data[0]['title'];
                                                      String playlistName =
                                                          playlists[index]
                                                              ['playlist'];
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            '$trackName added to $playlistName successfully !'),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      print(playlistBox
                                                          .get(index));
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                }),
                                          ),
                                        );
                                      });
                                },
                              )),
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
                                                          color: Color(
                                                              0xFF3A6878)),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text('Artist : Ed Sheeran',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Genera',
                                                            fontSize: 15.0,
                                                            color: Color(
                                                                0xFF3A6878))),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Text('Year : 2019',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Genera',
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
                                                  child: const Text(
                                                      'Search Lyrics'),
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
                              builder: (BuildContext context) => CurrentMusic(
                                  musicList: musics, currentIndex: index)));
                    },
                  )
                ],
              );
            });
  }
}
