import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:music_player/tabs/tracklist.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:music_player/tabs/search.dart';
import 'package:music_player/tabs/playlist.dart';
import 'package:music_player/tabs/settings.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
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
