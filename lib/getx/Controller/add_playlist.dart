import 'package:get/get.dart';
import 'package:hive/hive.dart';

class PlaylistController extends GetxController {
  var playlists = List.empty(growable: true);
  var playlistData = List.empty(growable: true).obs;
  var favoritesList = List.empty(growable: true).obs;

  @override
  // void onInit() {
  //   super.onInit();
  //   favoritesData();
  // }

  PlaylistController() {
    favoritesList.clear();
    favoritesData();
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
    print(favoritesList);
  }
}
