import 'package:assets_audio_player/assets_audio_player.dart' as audioPlayer;
import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/settings/player_settings.dart';
import 'package:music_player/main.dart';
import 'package:delayed_display/delayed_display.dart';

class Tracks extends StatefulWidget {
  const Tracks({Key? key}) : super(key: key);

  @override
  _TracksState createState() => _TracksState();
}

//AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

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
    setState(() {});
    // getSongs();

    // openTracks().then((value) {
    //   setState(() {
    //     musics = value[0];
    //   });
    // });
    // //openMusic();
    // openPlaylists().then((value) {
    //   setState(() {
    //     playlists = value;
    //   });
    // });
    setState(() {
      requestPermission();
    });
    super.initState();
    //requestPermission();
  }

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        var musicBox = await Hive.openBox('musicBox');
        var playlistBox = await Hive.openBox('playlistBox');
        var favorites = await Hive.openBox('favorites');
        //musicBox.put('tracks', []);
        //requestPermission();
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text(
        //         "You don't enabled permission, Please enable permission for this application")));
      }
      if (permissionStatus) {
        var musicBox = await Hive.openBox('musicBox');
        var playlistBox = await Hive.openBox('playlistBox');
        var favorites = await Hive.openBox('favorites');

        List<SongModel> musicList = await _audioQuery.querySongs();
        //print(musicList[0]);
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
        //print(musicData);
        musicBox.put('tracks', musicData);
        setState(() {
          musics = musicBox.get('tracks');
          for (var i = 0; i < playlistBox.length; i++) {
            playlists.add(playlistBox.getAt(i));
          }
        });
        //setState(() {
        //musics = musicBox.get('tracks');

        // });
      }
    }
  }

  Future<List> openTrack() async {
    final box = await Hive.openBox('musicBox');
    final List<dynamic> values = box.values.toList();
    return values;
  }

  getSongs() async {
    var musicBox = await Hive.openBox('musicBox');
    if (musicBox.isNotEmpty) {
      setState(() {
        musics = musicBox.get('tracks');
      });
    } else {
      setState(() {
        musics = [];
      });
    }
  }

  Future<List> openTracks() async {
    List mdata = [];
    var music = await Hive.openBox('musicBox');
    musics = music.values.toList();
    //musics.add(mdata);
    return musics;
  }

  Future<List> openPlaylists() async {
    var playlist = await Hive.openBox('playlistBox');
    playlists = playlist.values.toList();
    return playlists;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _playlist = TextEditingController();
    //List mu = music[0].toList();
    //final _tracks = music;
    return musics.isEmpty
        ? Center(
            child: Column(
            children: const [
              SizedBox(height: 20),
              Text('No tracks found !'),
              // CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              // ),
              SizedBox(height: 20),
            ],
          ))
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
                        fontFamily: 'Genera',
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
                        fontFamily: 'Genera',
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
                                        return SingleChildScrollView(
                                          child: Container(
                                            child: AlertDialog(
                                              title: Text('Add to Playlist'),
                                              content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2,
                                                width: double.maxFinite,
                                                child: Column(
                                                  children: [
                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            playlists.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                child: ListTile(
                                                                  title: Text(playlists[
                                                                          index]
                                                                      [
                                                                      'playlist']),
                                                                  onTap:
                                                                      () async {
                                                                    var playlistBox =
                                                                        await Hive.openBox(
                                                                            'playlistBox');
                                                                    print(data);
                                                                    if (playlistBox.getAt(index)[
                                                                            'tracks'] ==
                                                                        data) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        const SnackBar(
                                                                          content:
                                                                              Text(
                                                                            'Song already in playlist',
                                                                          ),
                                                                          duration:
                                                                              Duration(seconds: 1),
                                                                        ),
                                                                      );
                                                                    } else {
                                                                      playlists[index]
                                                                              [
                                                                              'tracks']
                                                                          .add(data[
                                                                              0]);
                                                                      setState(
                                                                          () {
                                                                        playlistBox.putAt(
                                                                            index,
                                                                            playlists[index]);
                                                                      });
                                                                      String
                                                                          trackName =
                                                                          data[0]
                                                                              [
                                                                              'title'];
                                                                      String
                                                                          playlistName =
                                                                          playlists[index]
                                                                              [
                                                                              'playlist'];
                                                                      final snackBar =
                                                                          SnackBar(
                                                                        content:
                                                                            Text('$trackName added to $playlistName successfully !'),
                                                                      );
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              snackBar);
                                                                    }
                                                                    // print(playlistBox
                                                                    //     .get(index));
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              )),
                              PopupMenuItem(
                                child: TextButton(
                                  child: Text('Song Info'),
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
                                                                  fontFamily:
                                                                      'Genera',
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
                                                                  fontFamily:
                                                                      'Genera',
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
                                                                    fontFamily:
                                                                        'Genera',
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
                                    child: Text('Share'),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'This feature is not availiable now.Will be implemented in next update !')));
                                    }),
                                value: 4,
                              ),
                            ]),
                    onTap: () async {
                      // final pathsforPlaying = [];
                      // for (var i = 0; i < musics.length; i++) {
                      //   pathsforPlaying.add(musics[i]['uri']);
                      // }
                      // var audios = <audioPlayer.Audio>[];
                      var currentSong = await Hive.openBox('currentSong');
                      currentSong.put('currentSong', musics);
                      currentSong.put('index', index);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CurrentMusic(
                                  musicList: musics, currentIndex: index)));

                      // final List<audioPlayer.Audio> _musicList = (musics)
                      //     .map((audio) => audioPlayer.Audio.file(audio['uri'],
                      //         metas: audioPlayer.Metas(
                      //             title: audio['title'], artist: audio['artist'])))
                      //     .toList();
                      // audioPlayerSettings.initializeAudioPlayerWithAudios(
                      //     _musicList, index);
                      //audioPlayerSettings.playSongAtIndex(index);
                    },
                  )
                ],
              );
            });
  }
}
