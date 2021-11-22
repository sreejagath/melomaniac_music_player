import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/db_model/playlist_model.dart';
import 'package:music_player/tabs/player.dart';
import 'package:music_player/tabs/tracklist.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List musics = [];
  List playlists = [];
  List playlistData = [];
  List favoritesList = [];
  @override
  void initState() {
    super.initState();
    musicSearch();
  }

  musicSearch() async {
    var musicBox = await Hive.openBox('musicBox');
    var playlistBox = await Hive.openBox('playlistBox');
    var favoritesBox = await Hive.openBox('favorites');
    setState(() {
      musics = musicBox.get('tracks');
      for (var i = 0; i < playlistBox.length; i++) {
        playlistData.add(playlistBox.getAt(i));
      }
      for (var i = 0; i < musics.length; i++) {
        if (musics[i]['isFavorite'] == true) {
          favoritesList.add(musics[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _playlist = TextEditingController();
    TextEditingController newPlaylistName = TextEditingController();
    int _len = musics.length;
    List<bool> isChecked = List.generate(_len, (index) => false);
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(children: [
              TextButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add to Playlist'),
                          content: TextField(
                            controller: _playlist,
                            decoration: InputDecoration(
                              hintText: 'Playlist Name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Add'),
                              onPressed: () async {
                                var playlistBox =
                                    await Hive.openBox('playlistBox');
                                setState(() {
                                  playlists = [
                                    {'playlist': _playlist.text, 'tracks': []}
                                  ];
                                  playlistBox.add(playlists[0]);
                                  playlistData.add(playlistBox
                                      .getAt(playlistBox.length - 1));
                                });
                                String playlistName = _playlist.text;
                                final snackBar = SnackBar(
                                  content: Text(
                                      'Created  Playlist $playlistName Successfully !\nPlease add song manually !\nTracks > Options > Add to playlist'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 5),
                    Text('New Playlist')
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  onTap: () async {
                    var favBox = await Hive.openBox('favorites');

                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: favoritesList.isEmpty
                                ? ListTile(
                                    leading: Icon(Icons.favorite_border),
                                    title: Text('No Favorites'),
                                    subtitle:
                                        Text('Add some songs to favorites'),
                                  )
                                : ListView.builder(
                                    itemCount: favoritesList.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Icon(Icons.music_note),
                                        title:
                                            Text(favoritesList[index]['title']),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CurrentMusic(
                                                        musicList:
                                                            favoritesList,
                                                        currentIndex: index,
                                                      )));
                                        },
                                        subtitle: Text(
                                            favoritesList[index]['artist']),
                                        trailing: PopupMenuButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                      child: TextButton(
                                                          onPressed: (){
                                                            // Hive.box('favorites').deleteAt(index);
                                                            // favoritesList.removeAt(index);
                                                            // Hive.box('musicBox').
                                                            setState(() {
                                                              favoritesList = favoritesList;
                                                            });
                                                          },
                                                          child: Text(
                                                              'Remove from Playlist'))),
                                                  // const PopupMenuItem(
                                                  //     child: Text(
                                                  //         'Add to playlist')),
                                                  // PopupMenuItem(
                                                  //     child: TextButton(
                                                  //   onPressed: () {},
                                                  //   child: const Text(
                                                  //     'Song Info',
                                                  //     textAlign: TextAlign.left,
                                                  //     style: TextStyle(
                                                  //         color: Colors.black),
                                                  //   ),
                                                  // )),
                                                  // const PopupMenuItem(
                                                  //     child:
                                                  //         Text('View Album')),
                                                  // const PopupMenuItem(
                                                  //     child: Text('Share')),
                                                ]),
                                      );
                                    },
                                  ),
                          );
                        });
                  }),
              ListView.builder(
                itemCount: playlistData.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.black),
                    title: Text(
                      playlistData[index]['playlist'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontFamily: 'Genera'),
                    ),
                    subtitle: Text(
                      playlistData[index]['tracks'].length.toString() +
                          ' Songs',
                      style: const TextStyle(fontFamily: 'Genera'),
                    ),
                    onTap: () async {
                      var favBox = await Hive.openBox('favorites');
                      var playlistBox = await Hive.openBox('playlistBox');
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: playlistData[index]['tracks'].isEmpty
                                  ? ListTile(
                                      leading: Icon(Icons.music_note),
                                      title: Text('No Songs'),
                                      subtitle: Text(
                                          'Please add song manually !\nTracks > Options > Add to playlist'),
                                    )
                                  : ListView.builder(
                                      itemCount:
                                          playlistData[index]['tracks'].length,
                                      itemBuilder: (context, values) {
                                        return ListTile(
                                          leading: Icon(Icons.music_note),
                                          title: Text(playlistData[index]
                                              ['tracks'][values]['title']),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CurrentMusic(
                                                          musicList:
                                                              playlistData[
                                                                      index]
                                                                  ['tracks'],
                                                          currentIndex: values,
                                                        )));
                                          },
                                          subtitle: Text(playlistData[index]
                                              ['tracks'][values]['artist']),
                                          trailing: PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0)),
                                              itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                        child: TextButton(
                                                      onPressed: () {
                                                        showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                            title: const Text(
                                                                'Confirmation'),
                                                            content: const Text(
                                                                'Are you sure to Remove ?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  List temp = playlistData[
                                                                          index]
                                                                      [
                                                                      'tracks'];
                                                                  temp.removeAt(
                                                                      values);
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    playlistData[
                                                                            index]
                                                                        [
                                                                        'tracks'] = temp;
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                          'Remove from playlist'),
                                                    )),
                                                  ]),
                                        );
                                      },
                                    ),
                            );
                          });
                    },
                    trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  child: TextButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Confirmation'),
                                    content:
                                        const Text('Are you sure to Delete ?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          var playlistBox =
                                              await Hive.openBox('playlistBox');
                                          playlistBox.deleteAt(index);

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {
                                            playlistData.removeAt(index);
                                          });
                                        },
                                        child: const Text('OK'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const Text('Delete Playlist',
                                    style: TextStyle(color: Colors.red)),
                              )),
                              PopupMenuItem(
                                  child: TextButton(
                                      child: const Text(
                                        'Rename',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: Form(
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              newPlaylistName,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'New Playlist Name',
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                title: const Text('Rename'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      var playlistBox =
                                                          await Hive.openBox(
                                                              'playlistBox');
                                                      playlistData[index]
                                                              ['playlist'] =
                                                          newPlaylistName.text;
                                                      setState(() {
                                                        playlistData[index]
                                                                ['playlist'] =
                                                            newPlaylistName
                                                                .text;
                                                        playlistBox.putAt(
                                                            index,
                                                            playlistData[
                                                                index]);
                                                      });
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                ],
                                              );
                                            });
                                      })),
                            ]),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
