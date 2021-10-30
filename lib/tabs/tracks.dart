import 'package:assets_audio_player/assets_audio_player.dart' as audioPlayer;
import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/settings/player_settings.dart';
import 'package:music_player/main.dart';

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
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
        requestPermission();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "You don't enabled permission, Please enable permission for this application")));

        musics = [];
      }
      if (permissionStatus) {
        var musicBox = await Hive.openBox('musicBox');
        var playlistBox = await Hive.openBox('playlistBox');

        List<SongModel> musicList = await _audioQuery.querySongs();

        musicList.forEach((element) {
          musicData.add({
            'title': element.title,
            'artist': element.artist,
            'id': element.id,
            'uri': element.uri,
            'album': element.album,
            'duration': element.duration,
            'isFavorite': false,
          });
        });
        print(musicData);
        musicBox.add(musicData);
        setState(() {
          musics = musicBox.getAt(0);
          for (var i = 0; i < playlistBox.length; i++) {
            playlists.add(playlistBox.getAt(i));
          }
        });
      }
    }
    for (var i = 0; i < musicData.length; i++) {
      pathsForPlaying.add(musicData[i]['uri']);
    }
    //await initializeAudiosForPlaying();
    //await audioPlayerSettings.initializeAudioPlayerWithAudios(audiosForPlaying);
    //print(audiosForPlaying);
  }

  var audiosForPlaying = <audioPlayer.Audio>[];
  Future<void> initializeAudiosForPlaying() async {
    await Future.forEach(pathsForPlaying, (path) async {
      audiosForPlaying.add(await audioPlayer.Audio.file(path.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _playlist = TextEditingController();
    //List mu = music[0].toList();
    //final _tracks = music;
    return musics == []
        ? Center(
            child: Column(
            children: const [
              Text('Add some music or check your permission settings.!'),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
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
                    ),
                    trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                  child: TextButton(
                                child: Text('Add to playlist'),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: AlertDialog(
                                                  title:
                                                      Text('Add to Playlist'),
                                                  content: Container(
                                                    height:
                                                        MediaQuery.of(context)
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
                                                            itemCount: playlists
                                                                .length,
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
                                                                    child:
                                                                        ListTile(
                                                                      title: Text(
                                                                          playlists[index]
                                                                              [
                                                                              'playlist']),
                                                                      onTap:
                                                                          () async {
                                                                        var playlistBox =
                                                                            await Hive.openBox('playlistBox');
                                                                        playlists[index]['tracks']
                                                                            .add(data[0]);
                                                                        setState(
                                                                            () {
                                                                          playlistBox.putAt(
                                                                              index,
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
                                            ],
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
