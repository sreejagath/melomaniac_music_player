import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:music_player/getx/Controller/add_playlist.dart';
import 'package:music_player/tabs/player.dart';
import 'package:path/path.dart';

class PlaylistData extends StatelessWidget {
  const PlaylistData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlistWithGetx = Get.put(PlaylistController());
    return Container(
        child: SingleChildScrollView(
            child: Column(
      children: [
        addToPlaylist(context),
        const SizedBox(height: 5),
        favorites(context, playlistWithGetx),
      ],
    )));
  }

  Widget addToPlaylist(context) {
    TextEditingController _playlistName = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          TextButton(
              onPressed: () {
                //showDialog
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("New Playlist"),
                        content: TextField(
                          controller: _playlistName,
                          decoration: const InputDecoration(
                            hintText: "Playlist Name",
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          ElevatedButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Row(
                children: const [
                  Icon(Icons.add),
                  SizedBox(
                    width: 5,
                  ),
                  Text('New playlist'),
                ],
              ))
        ],
      ),
    );
  }

  Widget favorites(context, playlistWithGetx) {
    return Column(
      children: [
        ListTile(
          title: const Text("Favorites"),
          leading: const Icon(Icons.favorite),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Obx(()=>
                        ListView.builder(
                          itemCount: playlistWithGetx.favoritesList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                leading: const Icon(Icons.music_note),
                                title: Text(playlistWithGetx
                                    .favoritesList[index]['title']),
                                onTap: () {
                                  Navigator.push(
                                              context,MaterialPageRoute(
                                                  builder: (context) =>
                                                      CurrentMusic(
                                                        musicList:
                                                            playlistWithGetx.favoritesList,
                                                        currentIndex: index,
                                                      )));
                                },
                                subtitle: Text(playlistWithGetx
                                    .favoritesList[index]['artist']));
                          },
                        ),
                      )
                      );
                });
          },
        )
      ],
    );
  }
}
