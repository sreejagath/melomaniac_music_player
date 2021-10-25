import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';

class AlbumList extends StatefulWidget {
  final List albumList;
  const AlbumList({Key? key, required this.albumList}) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                  itemCount: widget.albumList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Icon(Icons.album),
                      title: Text(widget.albumList[index]['title']),
                      subtitle: Text(widget.albumList[index]['artist']),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => CurrentMusic(
                                    musicList: widget.albumList, currentIndex: index)));
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
