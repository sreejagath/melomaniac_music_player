import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  _MusicListState createState() => _MusicListState();
}

List musics = [];
void initState() async {
  var musicBox = await Hive.openBox('musicBox');
  
  musics = musicBox.get(1);
}

class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
        });
  }
}
