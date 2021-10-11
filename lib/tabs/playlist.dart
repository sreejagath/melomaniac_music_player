import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  List<String> Playlist = [
    'Sleepy',
    'Romantic',
    'Rahman Hits',
    'Malayalam',
    'Tamil'
  ];

  List<String> PlaylistCount = [
    '234 Songs',
    '122 Songs',
    '12 Songs',
    '26 Songs',
    '28 Songs',
  ];

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
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0))),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Form(
                                child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text('New Playlist',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    decoration: const InputDecoration(
                                  hintText: 'New Playlist',
                                  prefixIcon: Icon(Icons.add),
                                )),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Create'))
                              ],
                            ))),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('New Playlist'),
                      ],
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        itemCount: trackTitle.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.music_note),
                            title: TextButton(
                              style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft),
                              child: Text(trackTitle[index]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CurrentMusic(

                                              musicList: music,
                                            )));
                              },
                            ),
                            subtitle: Text(trackArtist[index]),
                            trailing: PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          child: Text('Add to queue')),
                                      const PopupMenuItem(
                                          child: Text('Add to playlist')),
                                      PopupMenuItem(
                                          child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Text(
                                                            'Title : On My Way',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Genera',
                                                                fontSize: 20.0,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Text(
                                                            'Artist : Ed Sheeran',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Genera',
                                                                fontSize: 15.0,
                                                                color: Color(
                                                                    0xFF3A6878)),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Text(
                                                              'Artist : Ed Sheeran',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Genera',
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Color(
                                                                      0xFF3A6878))),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          Text('Year : 2019',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Genera',
                                                                  fontSize:
                                                                      15.0,
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
                                                  )));
                                        },
                                        child: const Text(
                                          'Song Info',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                      const PopupMenuItem(
                                          child: Text('View Album')),
                                      const PopupMenuItem(child: Text('Share')),
                                    ]),
                          );
                        },
                      ),
                    );
                  });
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.black),
                  title: Text(
                    Playlist[index],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontFamily: 'Genera'),
                  ),
                  subtitle: Text(
                    PlaylistCount[index],
                    style: const TextStyle(fontFamily: 'Genera'),
                  ),
                  trailing: PopupMenuButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: TextButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirmation'),
                                  content:
                                      const Text('Are you sure to Delete ?'),
                                  actions: <Widget>[
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
                            PopupMenuItem(
                                child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Add Tracks',
                                      style: TextStyle(color: Colors.black),
                                    ))),
                          ]),
                );
              },
              itemCount: Playlist.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}
