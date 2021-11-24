import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive/hive.dart';

class AlbumController extends GetxController {
  var albumList = List.empty(growable: true).obs;
  var songsList = List.empty(growable: true).obs;
  var listAlbumSongs = List.empty(growable: true).obs;

  final OnAudioQuery _audioQuery = OnAudioQuery();

  //onint
  @override
  void onInit() {
    listAlbums();
    listSongs();
    super.onInit();
  }

  listAlbums() async {
    List<AlbumModel> album = await _audioQuery.queryAlbums();
    album.forEach((element) {
      albumList.add({'album': element.album});
    });
    return albumList;
  }

  listSongs() async {
    List? musics = [];
    var musicBox = await Hive.openBox('musicBox');
    if (musicBox.isNotEmpty) {
      musics = musicBox.get('tracks');
      songsList.add(musics);
    } else {
      songsList;
    }
  }

  listAlbumData(List songs) async {
    listAlbumSongs.add(songs);
    //print(songs);
    return listAlbumSongs;
  }
}
