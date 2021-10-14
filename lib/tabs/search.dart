import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';

class SearchTrack extends StatefulWidget {
  const SearchTrack({Key? key}) : super(key: key);

  @override
  _SearchTrackState createState() => _SearchTrackState();
}

class _SearchTrackState extends State<SearchTrack> {
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
    return SingleChildScrollView(
      child: Form(
          child: Column(children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Search...',
              // labelStyle: TextStyle(
              //   color: Colors.black,
              // // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black),),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: music.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
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
                      onTap: () {
                        print(music[index]);
                        print(music);
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
                  ],
                );
              },
            ),
          ],
        )
      ])),
    );
  }
}
