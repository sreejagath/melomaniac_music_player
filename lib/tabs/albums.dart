import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:hive/hive.dart';
import 'package:music_player/tabs/albumlist.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List musics = [];
  List albumDatas = [];
  @override
  void initState() {
    super.initState();
    getSongs();
    getAlbums();
  }

  getSongs() async {
    var musicBox = await Hive.openBox('musicBox');
    if (musicBox.isNotEmpty) {
      setState(() {
        musics = musicBox.get('tracks');
      });
    } else {
      setState(() {
        musics = [];
      });
    }
  }

  getAlbums() async {
    List<AlbumModel> album = await _audioQuery.queryAlbums();
    album.forEach((element) {
      albumDatas.add({'album': element.album});
    });
  }

  @override
  Widget build(BuildContext context) {
    return musics.isEmpty
        ? Container(
            child: const Center(
            child: Text('No Albums'),
          ))
        : Container(
            child: ListView.builder(
              itemCount: albumDatas.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.album),
                        title: Text(albumDatas[index]['album']),
                        onTap: () async {
                          List albumList = [];
                        for (var i = 0; i < musics.length; i++) {
                          if (musics[i]['album'] == albumDatas[index]['album']) {
                            albumList.add(musics[i]);
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumList(
                              albumList: albumList,
                            ),
                          ),
                        );
                        },
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}