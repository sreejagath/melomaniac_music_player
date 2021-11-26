import 'package:flutter/material.dart';
import 'package:music_player/db_model/favorites_model.dart';
import 'package:music_player/db_model/playlist_model.dart';
import 'package:music_player/settings/player_settings.dart';
import 'package:music_player/tabs/getstarted.dart';
import 'package:music_player/tabs/player.dart';
import 'package:music_player/tabs/tracklist.dart';
import 'package:music_player/tabs/search.dart';
import 'package:music_player/tabs/playlist.dart';
import 'package:music_player/tabs/playlist_page.dart';
import 'package:music_player/tabs/settings.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/db_model/data_model.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();
List musicData = [];
List musics = [];
List playlists = [];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(GetMaterialApp(
    theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
    ),
    home: HomePage(),
  ));
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
    const PlaylistData(),
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
              color: Colors.black,),
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
              
              :Get.to(const Player());
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
