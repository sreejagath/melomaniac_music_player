import 'package:flutter/material.dart';
import 'package:music_player/tabs/albums.dart';
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
    _tabController = TabController(vsync: this, length: 2);
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
                  child: Text('Tracks',
                      style:
                          TextStyle(color: Colors.black)),
                ),
                Tab(
                  child: Text('Albums',
                      style:
                          TextStyle(color: Colors.black)),
                ),
              ]),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                child: const Tracks(),
              ),
              Container(child: const Albums()),
            ],
          ),
        ),
      ]),
    );
  }
}
