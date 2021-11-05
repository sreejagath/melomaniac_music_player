
import 'package:flutter/material.dart';
import 'package:music_player/db_model/favorites_model.dart';
import 'package:music_player/db_model/playlist_model.dart';
import 'package:music_player/settings/player_settings.dart';
import 'package:music_player/tabs/player.dart';
import 'package:music_player/tabs/tracklist.dart';
import 'package:music_player/tabs/search.dart';
import 'package:music_player/tabs/playlist.dart';
import 'package:music_player/tabs/settings.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/db_model/data_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();
List musicData = [];
List musics = [];
List playlists = [];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Genera',
    ),
    home: HomePage(),
  ));
  //requestPermission();
  Hive.registerAdapter(MusicModelAdapter());
  Hive.registerAdapter(PlaylistModelAdapter());
  Hive.registerAdapter(FavoritesModelAdapter());
}


  final audioPlayerSettings = AudioPlayerSettings();
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static int _selectedIndex = 0;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

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

  static final List<Widget> _widgetOptions = <Widget>[
    const Tracklist(),
    const SearchTrack(),
    const PlaylistPage(),
    const Settings(),
  ];

  final audioPlayerSettings = AudioPlayerSettings();
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
              Icons.music_note,
              color: Colors.black,
            ),
            label: 'Tracks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Search',
          ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var currentMusic = await Hive.openBox('LastPlayed');
          List? currentSong = currentMusic.get('currentSong');
          var index = currentMusic.get('index');
          currentSong == null
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('No songs played yet.'),
                ))
              : Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CurrentMusic(
                    musicList: currentSong,
                    currentIndex: index,
                  );
                }));
        },
        label: Text('Last Played'),
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
