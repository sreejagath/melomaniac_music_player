import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:music_player/tabs/player.dart';

class Tracks extends StatefulWidget {
  const Tracks({Key? key}) : super(key: key);

  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
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
      'artist': 'Rajesh Murugeshan',
      'url': 'assets/music/song.mp3',
      'image': 'assets/images/malare.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    //List mu = music[0].toList();
    //final _tracks = music;
    return ListView.builder(
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
                    backgroundImage: AssetImage(music[index]['image']),
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
                    print(music[index]);
                    print(music);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CurrentMusic(
                                musicList: music,)));
                  },
                ),
                const Divider(
                  color: Colors.black,
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
