import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:music_player/getx/Controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:music_player/main.dart';

bool isPlaying = false;
String trackArtist = "";
String trackTitle = "";
int trackId = 0;
int track = 0;
bool? notifications;
List pathsForPlaying = [];
Duration? duration;
bool isFavorite = false;
final assetsAudioPlayer = AssetsAudioPlayer();

class Player extends StatelessWidget {
  const Player({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final argsController = Get.put(PlayerController());
    argsController.getData(Get.arguments);
    var musics = argsController.argumentData[0];
    var currentIndex = argsController.argumentData[1];
    trackArtist = musics[currentIndex]['artist'];
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Playing Now',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(children: [
        const SizedBox(
          height: 50,
        ),
        Obx(
          () => artImage(
            argsController.trackId,
            musics,
            currentIndex,
          ),
        ),
        const SizedBox(
          height: 80,
        ),
        Obx(() => trackDetails(
            argsController.trackTitle, argsController.trackArtist, context)),
        audioPlayerSettings.infos(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                audioPlayerSettings.playPrevious();
              },
              icon: const Icon(Icons.skip_previous),
            ),
            const SizedBox(
              width: 12,
            ),
            IconButton(
              onPressed: () {
                audioPlayerSettings.seekByBackward();
              },
              icon: const Icon(Icons.fast_rewind),
            ),
            const SizedBox(
              width: 12,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: IconButton(
                iconSize: 35,
                icon: Obx(
                  () => Icon(argsController.isPlaying.isTrue
                      ? Icons.pause
                      : Icons.play_arrow),
                ),
                onPressed: () {
                  audioPlayerSettings.playOrPauseAudio();
                },
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            IconButton(
              onPressed: () {
                audioPlayerSettings.seekByForward();
              },
              icon: const Icon(Icons.fast_forward),
            ),
            const SizedBox(
              width: 12,
            ),
            IconButton(
                onPressed: () {
                  audioPlayerSettings.playNext();
                },
                icon: const Icon(Icons.skip_next)),
          ],
        )
      ]),
    );
  }

  Widget artImage(obxTrackId, musics, currentIndex) {
    obxTrackId = obxTrackId.value;
    return Container(
      height: 250,
      width: 250,
      child: QueryArtworkWidget(
        artworkFit: BoxFit.cover,
        id: trackId == 0 ? obxTrackId : trackId,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: const CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.music_note,
            size: 80,
          ),
        ),
      ),
    );
  }

  Widget trackDetails(trackTitle, trackArtist, context) {
    trackTitle = trackTitle.toString();
    trackArtist = trackArtist.toString();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              trackTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              trackArtist.length > 20
                  ? trackArtist.replaceRange(20, trackArtist.length, '...')
                  : trackArtist,
              style: const TextStyle(
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
