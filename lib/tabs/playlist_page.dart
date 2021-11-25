import 'dart:ui';

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
        addToPlaylist(context, playlistWithGetx),
        const SizedBox(height: 5),
        favorites(context, playlistWithGetx),
        const SizedBox(height: 5),
        listPlaylists(context, playlistWithGetx),
      ],
    )));
  }

  Widget addToPlaylist(context, playlistWithGetx) {
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
                          decoration: InputDecoration(
                              hintText: "Playlist Name",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _playlistName.clear();
                                  },
                                  icon: const Icon(Icons.clear))),
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
                              playlistWithGetx
                                  .addNewPlaylist(_playlistName.text);
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
                  playlistWithGetx.favoritesData();
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Obx(
                        () => ListView.builder(
                          itemCount: playlistWithGetx.favoritesList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                leading: const Icon(Icons.music_note),
                                title: Text(playlistWithGetx
                                    .favoritesList[index]['title']),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CurrentMusic(
                                                musicList: playlistWithGetx
                                                    .favoritesList,
                                                currentIndex: index,
                                              )));
                                },
                                subtitle: Text(playlistWithGetx
                                    .favoritesList[index]['artist']),
                                trailing: PopupMenuButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    onSelected: (value) {
                                      if (value == 'delete') {
                                        playlistWithGetx.removeFavorite(index);
                                        Get.back();
                                        Get.snackbar(
                                          'Item Removed',
                                          'Song was removed from favorites.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: 'delete',
                                              child: Text(
                                                  'Remove from favorites',
                                                  style: TextStyle(
                                                      color: Colors.red)))
                                        ]));
                          },
                        ),
                      ));
                });
          },
        )
      ],
    );
  }

  Widget listPlaylists(context, playlistWithGetx) {
    return Container(
        child: Obx(
      () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: playlistWithGetx.playlistData.length,
          itemBuilder: (context, index) {
            return ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(playlistWithGetx.playlistData[index]['playlist']),
                subtitle: Text(playlistWithGetx
                        .playlistData[index]['tracks'].length
                        .toString() +
                    ' Songs'),
                trailing: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onSelected: (value) {
                      if (value == 'delete') {
                        playlistWithGetx.removePlaylist(index);
                        Get.back();
                        Get.snackbar(
                          'Item Removed',
                          'Playlist was removed.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                      if (value == 'rename') {
                        Get.back();
                      }
                    },
                    itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'delete',
                              child: Text('Remove playlist',
                                  style: TextStyle(color: Colors.red))),
                          const PopupMenuItem(
                            value: 'rename',
                            child: Text('Rename playlist'),
                          ),
                        ]),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                            itemCount: playlistWithGetx
                                .playlistData[index]['tracks'].length,
                            itemBuilder: (context, values) {
                              return ListTile(
                                  title: Text(
                                      playlistWithGetx.playlistData[index]
                                          ['tracks'][values]['title']),
                                  subtitle: Text(
                                      playlistWithGetx.playlistData[index]
                                          ['tracks'][values]['artist']),
                                  leading: const Icon(Icons.music_note),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CurrentMusic(
                                                  musicList: playlistWithGetx
                                                          .playlistData[index]
                                                      ['tracks'],
                                                  currentIndex: values,
                                                )));
                                  },
                                  trailing: PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      onSelected: (value) {
                                        if (value == 'delete') {
                                          // playlistWithGetx.removeTrack(
                                          //     playlistWithGetx
                                          //             .playlistData[index]
                                          //         ['tracks'],
                                          //     values);
                                          Get.back();
                                          Get.snackbar(
                                            'Item Removed',
                                            'Song was removed from playlist.',
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                            const PopupMenuItem(
                                                value: 'delete',
                                                child: Text(
                                                    'Remove from playlist',
                                                    style: TextStyle(
                                                        color: Colors.red)))
                                          ]));
                            },
                          ),
                        );
                      });
                });
          }),
    ));
  }
}
