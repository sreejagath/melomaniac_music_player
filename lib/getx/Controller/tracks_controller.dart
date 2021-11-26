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
    requestPermission();
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
        for (var i = 0; i < playlistBox.length; i++) {
          playlists.add(playlistBox.getAt(i));
        }
      }
    }
  }
}
