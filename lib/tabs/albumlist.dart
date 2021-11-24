import 'package:flutter/material.dart';
import 'package:music_player/getx/model/albumlisting.dart';
import 'package:music_player/tabs/player.dart';
import 'package:get/get.dart';

class AlbumList extends StatelessWidget {
const AlbumList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albumMusics = Get.find<AlbumController>();
    albumMusics.listAlbumSongs(Get.arguments);
    final albumList = albumMusics.listAlbumSongs;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Melomaniac',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: albumList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Icon(Icons.album),
                        title: Text(albumList[index]['title']),
                        subtitle: Text(albumList[index]['artist']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CurrentMusic(
                                          musicList: albumList,
                                          currentIndex: index)));
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
