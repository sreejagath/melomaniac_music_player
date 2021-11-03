import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';

class PlaylistData extends StatefulWidget {
  final List playlistDatas;
  const PlaylistData({Key? key, required this.playlistDatas}) : super(key: key);

  @override
  _PlaylistDataState createState() => _PlaylistDataState();
}

class _PlaylistDataState extends State<PlaylistData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            'Melomaniac',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Genera'),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.playlistDatas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.album),
                      title: Text(widget.playlistDatas[index]['title']),
                      subtitle: Text(widget.playlistDatas[index]['artist']),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => CurrentMusic(
                                    musicList: widget.playlistDatas,
                                    currentIndex: index)));
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
