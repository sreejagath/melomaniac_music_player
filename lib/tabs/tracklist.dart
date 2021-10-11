import 'package:flutter/material.dart';
import 'package:music_player/tabs/albums.dart';
import 'package:music_player/tabs/artists.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:music_player/tabs/tracks.dart';

class Tracklist extends StatefulWidget {
  const Tracklist({Key? key}) : super(key: key);

  @override
  _TracklistState createState() => _TracklistState();
}

class _TracklistState extends State<Tracklist>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: TabBar(
              indicator: DotIndicator(
                color: Colors.black,
                distanceFromCenter: 16,
                radius: 3,
                paintingStyle: PaintingStyle.fill,
              ),
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text('Tracks', style: TextStyle(color: Colors.black,fontFamily: 'Genera')),
                ),
                Tab(
                  child: Text('Albums', style: TextStyle(color: Colors.black,fontFamily: 'Genera')),
                ),
                Tab(
                  child: Text('Artists', style: TextStyle(color: Colors.black,fontFamily: 'Genera')),
                )
              ]),
        ),

        //TRACKS

        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                child: const Tracks(),
              ),

              //ALBUMS

              Container(child: const Albums()),

              //ARTISTS

              Container(
                child: const Artists()
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
