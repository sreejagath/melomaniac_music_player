import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:music_player/settings/player_settings.dart';

class PlayerController extends GetxController {
  var argumentData = List.empty(growable: true).obs;
  final audioPlayerSettings = AudioPlayerSettings();
  var trackTitle = ''.obs;
  var trackArtist = ''.obs;
  var trackId = ''.obs;
  var isPlaying = false.obs;

  PlayerController() {
    //argumentData.clear();
    getData(Get.arguments);
    List musics = argumentData[0];
    final List<Audio> audios = (musics)
        .map((audio) => Audio.file(audio['uri'],
            metas: Metas(
                title: audio['title'],
                artist: audio['artist'],
                id: audio['id'].toString(),
                extra: {'isFavorite': audio['isFavorite']})))
        .toList();
    audioPlayerSettings
        .initializePlayer(
      audios,
      argumentData[1],
    )
        .then((value) {
      audioPlayerSettings.currentValues.listen((current) {
        trackTitle(current!.audio.audio.metas.title);
        trackArtist(current.audio.audio.metas.artist);
        trackId(current.audio.audio.metas.id);

        // trackTitle = current.audio.audio.metas.title ?? 'No Title';
        // trackArtist = current.audio.audio.metas.artist ?? 'No Artist';
        // trackId = int.parse(current.audio.audio.metas.id!);
        // isFavorite = current.audio.audio.metas.extra!['isFavorite'];
        // if (mounted) {
        //   if (current == null) {
        //     return;
        //   } else {
        //     setState(() {
        //       trackTitle = current.audio.audio.metas.title ?? 'No Title';
        //       trackArtist = current.audio.audio.metas.artist ?? 'No Artist';
        //       trackId = int.parse(current.audio.audio.metas.id!);
        //       isFavorite = current.audio.audio.metas.extra!['isFavorite'];
        //     });
        //   }
        // }
      });
    }).then((value) =>
            audioPlayerSettings.isAudioPlayerPlaying.listen((isPlaying) {
              this.isPlaying(isPlaying);
              // if (mounted) {
              //   setState(() {
              //     this.isPlaying = isPlaying;
              //   });
              // }
            }));
  }


  getData(List arguments) async {
    argumentData(arguments);
    update();
    return argumentData;
  }
}
