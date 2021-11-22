import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'package:music_player/main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:on_audio_query/on_audio_query.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFcbe6f6),
      body: Center(
        child: ElevatedButton(
          child: Text('Get Started'),
          onPressed: () {
            Get.to(() => HomePage());
          },
        ),
      ),
    );
  }
}
