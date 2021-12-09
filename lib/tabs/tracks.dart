import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/getx/Controller/add_playlist.dart';
import 'package:music_player/getx/Controller/tracks_controller.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Track extends StatelessWidget {
  const Track({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trackListingWithGetX = Get.put(TrackController());

    //var playlists = trackListingWithGetX.playlists;
    return Obx(
      () => trackListingWithGetX.musicData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('No Songs Found !'),
                  DelayedDisplay(
                    child: Text(
                        'If you enabled permissions,please restart the app...'),
                    delay: Duration(seconds: 6),
                  )
                ],
              ),
            )
          : ListView.builder(
              itemCount: trackListingWithGetX.musics.length,
              itemBuilder: (context, index) {
                // return TrackListing(index: index);
                return ListTile(
                  title: Text(
                    trackListingWithGetX.musics[index]['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    trackListingWithGetX.musics[index]['artist'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: QueryArtworkWidget(
                      id: trackListingWithGetX.musics[index]['id'],
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onSelected: (value) {
                      if (value == 4) {
                        Get.snackbar('Feature not availiable',
                            'This feature is not availiable now.Will be implemented in next update !');
                      }
                      if (value == 3) {
                        Get.snackbar('Feature not availiable',
                            'This feature is not availiable now.Will be implemented in next update !');
                      }
                      if (value == 2) {
                        trackListingWithGetX.addToFavorites(index);
                        Get.back();
                        Get.snackbar(
                          'Added Successfully',
                          'Song added to favorites successfully !',
                        );
                      }
                      if (value == 1) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              final playlistListing =
                                  Get.put(PlaylistController());
                              return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Add to Playlist',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: Obx(
                                          () => ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: playlistListing
                                                .playlistData.length,
                                            itemBuilder: (context, values) {
                                              //print();
                                              print(index);
                                              return ListTile(
                                                title: Text(playlistListing
                                                        .playlistData[values]
                                                    ['playlist']),
                                                onTap: () {
                                                  List data = [
                                                    {
                                                      'title':
                                                          trackListingWithGetX
                                                                  .musics[index]
                                                              ['title'],
                                                      'artist':
                                                          trackListingWithGetX
                                                                  .musics[index]
                                                              ['artist'],
                                                      'uri':
                                                          trackListingWithGetX
                                                                  .musics[index]
                                                              ['uri'],
                                                      'id': trackListingWithGetX
                                                          .musics[index]['id'],
                                                      'album':
                                                          trackListingWithGetX
                                                                  .musics[index]
                                                              ['album'],
                                                      'duration':
                                                          trackListingWithGetX
                                                                  .musics[index]
                                                              ['duration'],
                                                      'isFavorite':
                                                          trackListingWithGetX
                                                                  .musics[index]
                                                              ['isFavorite'],
                                                    }
                                                  ];
                                                  playlistListing.addToPlaylist(
                                                    data,
                                                    values,
                                                  );
                                                  Get.back();
                                                  Get.back();
                                                  Get.snackbar(
                                                      'Added Succesfully',
                                                      'Song added to playlist successfully !');
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            });
                      }
                    },
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text('Add to Playlist'),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text('Add to Favorites'),
                        value: 2,
                      ),
                      const PopupMenuItem(
                        child: Text('Song Info'),
                        value: 3,
                      ),
                      const PopupMenuItem(
                        child: Text('Share'),
                        value: 4,
                      ),
                    ],
                    // onSelected: (value) {
                    //   if (value == 3) {
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(const SnackBar(
                    //       content: Text(
                    //           'This feature is not availiable now.Will be implemented in next update !'),
                    //     ));
                    //   }
                    // },
                  ),
                  onTap: () async {
                    var currentSong = await Hive.openBox('LastPlayed');
                    currentSong.put('currentSong', trackListingWithGetX.musics);
                    currentSong.put('index', index);
                    Get.to(Player(),
                        arguments: [trackListingWithGetX.musics, index]);
                  },
                );
              },
            ),
    );
  }
}
