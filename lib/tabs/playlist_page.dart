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
                                  Get.to(Player());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //         Player()
                                  //         // CurrentMusic(
                                  //         //       musicList: playlistWithGetx
                                  //         //           .favoritesList,
                                  //         //       currentIndex: index,
                                  //         //     )
                                  //             ));
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
    TextEditingController newPlaylistName = TextEditingController();
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
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Rename Playlist"),
                                content: TextField(
                                  controller: newPlaylistName,
                                  decoration: InputDecoration(
                                      hintText: "Playlist Name",
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            newPlaylistName.clear();
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
                                      playlistWithGetx.renamePlaylist(
                                        index,
                                        newPlaylistName.text,
                                      );
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            });
                        //Get.back();
                      }
                    },
                    itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'delete',
                              child: Text('Remove playlist',
                                  style: TextStyle(color: Colors.red))),
                          const PopupMenuItem(
                            value: 'rename',
                            child: Text('Rename'),
                          ),
                        ]),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: playlistWithGetx
                                  .playlistData[index]['tracks'].isEmpty
                              ? const ListTile(
                                  leading: Icon(Icons.music_note),
                                  title: Text('No Songs'),
                                  subtitle: Text(
                                      'Please add song manually !\nTracks > Options > Add to playlist'),
                                )
                              : ListView.builder(
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
                                          Get.to(Player());
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             CurrentMusic(
                                          //               musicList: playlistWithGetx
                                          //                       .playlistData[
                                          //                   index]['tracks'],
                                          //               currentIndex: values,
                                          //             )));
                                        },
                                        trailing: PopupMenuButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            onSelected: (value) {
                                              if (value == 'delete') {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                          title: const Text(
                                                              'Are you sure?'),
                                                          content: const Text(
                                                              'This will remove the song from the playlist.'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child: const Text(
                                                                    'Cancel')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  playlistWithGetx
                                                                      .removeTrack(
                                                                          index,
                                                                          values);

                                                                  Get.back();
                                                                  Get.back();
                                                                  Get.snackbar(
                                                                    'Item Removed',
                                                                    'Song was removed from playlist.',
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                  );
                                                                },
                                                                child: const Text(
                                                                    'OK',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red))),
                                                          ]);
                                                    });
                                              }
                                            },
                                            itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                      value: 'delete',
                                                      child: Text(
                                                          'Remove from playlist',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)))
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
