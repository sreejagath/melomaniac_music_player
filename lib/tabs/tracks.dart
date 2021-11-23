import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/settings/player_settings.dart';

class Tracks extends StatefulWidget {
  const Tracks({Key? key}) : super(key: key);

  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List musics = [];
  List playlists = [];
  List musicData = [];
  List playlistData = [];
  final List pathsForPlaying = [];
  final audioPlayerSettings = AudioPlayerSettings();

  @override
  void initState() {
    setState(() {
      requestPermission();
    });
    setState(() {});
    super.initState();
  }

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        var musicBox = await Hive.openBox('musicBox');
        var playlistBox = await Hive.openBox('playlistBox');
        var favorites = await Hive.openBox('favorites');
        var currentSong = await Hive.openBox('currentSong');
      }
      if (permissionStatus) {
        var musicBox = await Hive.openBox('musicBox');
        var playlistBox = await Hive.openBox('playlistBox');
        var favorites = await Hive.openBox('favorites');
        //var currentSong = await Hive.openBox('currentSong');

        List<SongModel> musicList = await _audioQuery.querySongs();
        musicList.forEach((element) {
          musicData.add({
            'title': element.title,
            'artist': element.artist,
            'id': element.id,
            'uri': element.uri,
            'album': element.album,
            'duration': element.duration,
            'isFavorite': favorites.containsKey(element.id)
          });
        });
        musicBox.put('tracks', musicData);
        setState(() {
          musics = musicBox.get('tracks');
          for (var i = 0; i < playlistBox.length; i++) {
            playlists.add(playlistBox.getAt(i));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return musics.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: const Center(
                child: Text('No Tracks'),
              )),
              const DelayedDisplay(
                child: Text(
                    'If you enabled permissions,please restart the app...'),
                delay: Duration(seconds: 4),
              )
            ],
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: musics.length,
            itemBuilder: (BuildContext context, int index) {
              List data = [
                {
                  'title': musics[index]['title'],
                  'artist': musics[index]['artist'],
                  'uri': musics[index]['uri'],
                  'id': musics[index]['id'],
                  'album': musics[index]['album'],
                  'duration': musics[index]['duration'],
                  'isFavorite': musics[index]['isFavorite'],
                }
              ];
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      musics[index]['title'].length > 28
                          ? musics[index]['title'].replaceRange(
                              28, musics[index]['title'].length, '...')
                          : musics[index]['title'],
                      style: const TextStyle(
                        //fontFamily: 'Genera',
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      musics[index]['artist'].length > 28
                          ? musics[index]['artist'].replaceRange(
                              28, musics[index]['artist'].length, '...')
                          : musics[index]['artist'],
                      style: const TextStyle(
                        //fontFamily: 'Genera',
                        fontSize: 15.0,
                        color: Color(0xFF3A6878),
                      ),
                    ),
                    leading: QueryArtworkWidget(
                      id: musics[index]['id'],
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        size: 30,
                      ),
                    ),
                    trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                child: TextButton(
                                  child: Text('Add to Favorites'),
                                  onPressed: () {
                                    setState(() {
                                      musics[index]['isFavorite'] = true;
                                      Hive.box('musicBox').put(
                                        'tracks',
                                        musics,
                                      );
                                      Hive.box('favorites').put(
                                          musics[index]['id'], musics[index]);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Added to Favorites',
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                  child: TextButton(
                                child: Text('Add to playlist'),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          child: AlertDialog(
                                            title: Text('Add to Playlist'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: double.maxFinite,
                                                  child: playlists.isEmpty
                                                      ? Container(
                                                          child: const Text(
                                                              'No Playlists\nCreate new from Playlist Section'),
                                                        )
                                                      : ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              playlists.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Container(
                                                              child: playlists
                                                                      .isEmpty
                                                                  ? Container(
                                                                      child:
                                                                          const Center(
                                                                        child: Text(
                                                                            'No Playlists\nCreate playlist manually from playlist section.'),
                                                                      ),
                                                                    )
                                                                  : ListTile(
                                                                      title: Text(
                                                                          playlists[index]
                                                                              [
                                                                              'playlist']),
                                                                      onTap:
                                                                          () async {
                                                                        var playlistBox =
                                                                            await Hive.openBox('playlistBox');

                                                                        if (playlistBox.getAt(index)['tracks'] ==
                                                                            data) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Text(
                                                                                'Song already in playlist',
                                                                              ),
                                                                              duration: Duration(seconds: 1),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          playlists[index]['tracks']
                                                                              .add(data[0]);
                                                                          setState(
                                                                              () {
                                                                            playlistBox.putAt(index,
                                                                                playlists[index]);
                                                                          });
                                                                          String
                                                                              trackName =
                                                                              data[0]['title'];
                                                                          String
                                                                              playlistName =
                                                                              playlists[index]['playlist'];
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            content:
                                                                                Text('$trackName added to $playlistName successfully !'),
                                                                          );
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(snackBar);
                                                                        }
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                            );
                                                          }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                              )),
                              PopupMenuItem(
                                child: TextButton(
                                  child: const Text('Song Info'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 120,
                                                          width: 120,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                QueryArtworkWidget(
                                                              id: musics[index]
                                                                  ['id'],
                                                              type: ArtworkType
                                                                  .AUDIO,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Title : ${musics[index]['title']}',
                                                              style: const TextStyle(
                                                                  
                                                                  fontSize:
                                                                      20.0,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Text(
                                                              'Artist : ${musics[index]['artist']}',
                                                              style: const TextStyle(
                                                                  
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Color(
                                                                      0xFF3A6878)),
                                                            ),
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            Text(
                                                                'Album : ${musics[index]['album']}',
                                                                style: const TextStyle(
                                                                    
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Color(
                                                                        0xFF3A6878))),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text('This feature is not availiable now.Will be implemented in next update !')));
                                                          },
                                                          child: const Text(
                                                              'Search Lyrics'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        });
                                  },
                                ),
                                value: 3,
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                    child: Text('Share'), onPressed: () {}),
                                value: 4,
                              ),
                            ],
                        onSelected: (value) {
                          if (value == 4) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  'This feature is not availiable now.Will be implemented in next update !'),
                            ));
                          }
                        }),
                    onTap: () async {
                      var currentSong = await Hive.openBox('LastPlayed');
                      currentSong.put('currentSong', musics);
                      currentSong.put('index', index);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CurrentMusic(
                                  musicList: musics, currentIndex: index)));
                    },
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                ],
              );
            });
  }
}
