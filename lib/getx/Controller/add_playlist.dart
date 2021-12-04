import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:music_player/getx/Controller/tracks_controller.dart';

class PlaylistController extends GetxController {
  var playlists = List.empty(growable: true);
  var playlistData = List.empty(growable: true).obs;
  var favoritesList = List.empty(growable: true).obs;

  @override
  PlaylistController() {
    favoritesList.clear();
    update();
    favoritesData();
    getPlaylist();
  }

  getPlaylist() async {
    playlistData.clear();
    var playlistBox = await Hive.openBox('playlistBox');
    for (var i = 0; i < playlistBox.length; i++) {
      playlistData.add(playlistBox.getAt(i));
    }
    print(playlistData);
    update();
  }

  addToPlaylist(data, index) async {
    var playlistBox = await Hive.openBox('playlistBox');
    playlistData[index]['tracks'].add(data[0]);
    playlistBox.putAt(index, playlistData[index]);
    update();
  }

  addNewPlaylist(String playlistName) async {
    var playlistBox = await Hive.openBox('playlistBox');
    playlists = [
      {'playlist': playlistName, 'tracks': []}
    ];
    playlistBox.add(playlists[0]);
    playlistData.add(playlistBox.getAt(playlistBox.length - 1));
  }

  favoritesData() async {
    List? musics;
    List? favs;
    var musicBox = await Hive.openBox('musicBox');
    var favorites = await Hive.openBox('favorites');
    musics = musicBox.get('tracks');
    favoritesList.clear();
    for (var i = 0; i < musics!.length; i++) {
      if (musics[i]['isFavorite'] == true) {
        favoritesList.add(musics[i]);
      }
    }
  }

  removeFavorite(int index) async {
    List? musics;
    var musicBox = await Hive.openBox('musicBox');
    musics = musicBox.get('tracks');
    Hive.box('favorites').delete(favoritesList[index]['id']);
    for (var i = 0; i < musics!.length; i++) {
      if (musics[i]['id'] == favoritesList[index]['id']) {
        print(musics[i]);
        musics[i]['isFavorite'] = false;
      }
    }
    Hive.box('musicBox').put(
      'tracks',
      musics,
    );
    favoritesList.removeAt(index);
  }

  removePlaylist(int index) async {
    var playlistBox = await Hive.openBox('playlistBox');
    playlistBox.deleteAt(index);
    playlistData.removeAt(index);
  }

  renamePlaylist(index, newName) async {
    print(newName);
    var playlistBox = await Hive.openBox('playlistBox');
    playlistData[index]['playlist'] = newName;
    playlistBox.putAt(index, playlistData[index]);
    getPlaylist();
    update();
  }

  removeTrack(int index, int values) async {
    playlistData.clear();
    var playlistBox = await Hive.openBox('playlistBox');
    for (var i = 0; i < playlistBox.length; i++) {
      playlistData.add(playlistBox.getAt(i));
    }
    print(playlistData);
    print('index: $index &values: $values ');
    playlistData[index]['tracks'].removeAt(values);
    playlistBox.putAt(index, playlistData[index]);
  }
}
