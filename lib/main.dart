// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/db_model/favorites_model.dart';
import 'package:music_player/db_model/playlist_model.dart';
import 'package:music_player/tabs/player.dart';
import 'package:music_player/tabs/tracklist.dart';
import 'package:music_player/tabs/search.dart';
import 'package:music_player/tabs/playlist.dart';
import 'package:music_player/tabs/settings.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/db_model/data_model.dart';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();
List musicData = [];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!kIsWeb) {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
  }
  runApp(GetMaterialApp(
    home: HomePage(),
  ));
  //requestPermission();
  Hive.registerAdapter(MusicModelAdapter());
  Hive.registerAdapter(PlaylistModelAdapter());
  Hive.registerAdapter(FavoritesModelAdapter());
  var musicBox = await Hive.openBox('musicBox');
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
  // for (var i = 0; i < musicList.length; i++) {
  //   musicBox.put(i, musicData);
  // }
  musicBox.add(musicData);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  late TabController _tabController;
  static int _selectedIndex = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  List music = [
    {
      'title': 'Malare',
      'artist': 'Rajesh Murugan',
      'url': 'assets/music/song.mp3',
      'id': 'assets/images/malare.jpg'
    }
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    Tracklist(),
    SearchTrack(),
    CurrentMusic(
      musicList: [
        {
          'title': 'Malare',
          'artist': 'Rajesh Murugan',
          'url': 'assets/music/song.mp3'
        }
      ],
      currentIndex: 0,
    ),
    Playlist(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Melomaniac',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Genera'),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            label: 'Tracks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Search',
          ),
          BottomNavigationBarItem(
              icon: Visibility(
                visible: false,
                child: Icon(
                  Icons.music_note_rounded,
                  color: Colors.black,
                  size: 0,
                ),
              ),
              label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CurrentMusic(
              musicList: music,
              currentIndex: 0,
            );
          }));
        },
        child: const Icon(
          Icons.music_note,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
