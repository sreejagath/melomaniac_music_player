import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TrackController extends GetxController {
  var musicData = List.empty(growable: true).obs;
  var musics = List.empty(growable: true).obs;
  var playlists = List.empty(growable: true).obs;

  TrackController() {
    update();
    requestPermission();
    update();
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();
  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      if (permissionStatus) {
        var musicBox = await Hive.openBox('musicBox');
        var playlistBox = await Hive.openBox('playlistBox');
        var favorites = await Hive.openBox('favorites');

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
        musics = musicBox.get('tracks');
        update();
        for (var i = 0; i < playlistBox.length; i++) {
          playlists.add(playlistBox.getAt(i));
        }
        update();
      }
    }
  }

  getMusicData() async {
    var musicBox = await Hive.openBox('musicBox');
    var playlistBox = await Hive.openBox('playlistBox');
    var favorites = await Hive.openBox('favorites');

    if (musicBox.get('tracks') != null) {
      musicData = musicBox.get('tracks');
      musics = musicBox.get('tracks');
    } else {
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
      musics = musicBox.get('tracks');
      update();
    }
    for (var i = 0; i < playlistBox.length; i++) {
      playlists.add(playlistBox.getAt(i));
    }
    update();
  }

  addToFavorites(index) async {
    var favorites = await Hive.openBox('favorites');
    var musicBox = await Hive.openBox('musicBox');
    musics[index]['isFavorite'] = true;
    Hive.box('musicBox').put(
      'tracks',
      musics,
    );
    Hive.box('favorites').put(musics[index]['id'], musics[index]);
    update();
  }

  addToPlaylist(data, index) async {
    var playlistBox = await Hive.openBox('playlistBox');
    playlists[index]['tracks'].add(data[0]);
    playlistBox.putAt(index, playlists[index]);
    update();
  }
}
