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
    print(musics);
  }

  getAlbums() async {
    List<AlbumModel> album = await _audioQuery.queryAlbums();
    album.forEach((element) {
      albumDatas.add({'album': element.album});
    });
    print(albumDatas);
  }

  @override
  Widget build(BuildContext context) {
    //String name = musics[0]['album'];
    return musics.isEmpty
        ? Container(
            child: Center(
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
                        leading: Icon(Icons.album),
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
          
        // : Container(
        //     child: SingleChildScrollView(
        //         child: Column(children: [
        //     const SizedBox(height: 15),
        //     GridView.builder(
        //       scrollDirection: Axis.vertical,
        //       shrinkWrap: true,
        //       physics: const ScrollPhysics(),
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //       ),
        //       itemCount: musics.length,
        //       itemBuilder: (context, index) {
        //         return GridTile(
        //           child: InkResponse(
        //               child: Container(
        //                   child: Column(children: [
        //                 Container(
        //                   width: 100.0,
        //                   height: 100.0,
        //                   decoration: const BoxDecoration(),
        //                   child: Column(
        //                     children: [
        //                       Container(
        //                         height: 60,
        //                         width: 60,
        //                         child: ClipRRect(
        //                           borderRadius: BorderRadius.circular(10.0),
        //                           child: QueryArtworkWidget(
        //                             id: musics[index]['id'],
        //                             type: ArtworkType.AUDIO,
        //                           ),
        //                         ),
        //                       ),
        //                       const SizedBox(
        //                         height: 20.0,
        //                       ),
        //                       Text(
        //                         musics[index]['album'].length > 10
        //                             ? musics[index]['album'].replaceRange(10,
        //                                 musics[index]['album'].length, '...')
        //                             : musics[index]['album'],
        //                         // style: const TextStyle(
        //                         //   fontFamily: 'Khyay',
        //                         //   fontSize: 15.0,
        //                         //   color: Color(0xFF3A6878),
        //                         // ),
        //                       ),
        //                     ],
        //                   ),
        //                 )
        //               ])),
        //               onTap: () {
        //                 List albumList = [];
        //                 for (var i = 0; i < musics.length; i++) {
        //                   if (musics[i]['album'] == musics[index]['album']) {
        //                     albumList.add(musics[i]);
        //                   }
        //                 }
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => AlbumList(
        //                               albumList: albumList,
        //                             )));
        //               }),
        //         );
        //       },
        //     )
        //   ])));
  

