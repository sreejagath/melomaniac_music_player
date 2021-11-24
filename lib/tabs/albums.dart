import 'package:flutter/material.dart';
import 'package:music_player/getx/Controller/albumlisting.dart';
import 'package:music_player/main.dart';
import 'package:hive/hive.dart';
import 'package:music_player/tabs/albumlist.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class Albums extends StatelessWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albumListingWithGetx = Get.put(AlbumController());
    return albumListingWithGetx.albumList.isEmpty
        ? Container(
            child: const Center(
            child: Text('No Albums'),
          ))
        : Obx(
            () => ListView.builder(
              itemCount: albumListingWithGetx.albumList.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.album),
                        title: Text(
                            albumListingWithGetx.albumList[index]['album']),
                        onTap: () {
                          List albumList = [];
                          List musics = albumListingWithGetx.songsList;
                          List mdata = musics[0];

                          for (var i = 0; i < mdata.length; i++) {
                            if (mdata[i]['album'] ==
                                albumListingWithGetx.albumList[index]
                                    ['album']) {
                              albumList.add(mdata[i]);
                            }
                          }
                          Get.to(const AlbumList(), arguments: albumList);
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
