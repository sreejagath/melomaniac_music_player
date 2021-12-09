import 'package:flutter/material.dart';
import 'package:music_player/tabs/albums.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:music_player/tabs/tracks.dart';
import 'package:get/get.dart';

class MyTabController extends GetxController with SingleGetTickerProviderMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(
      child: Text('Tracks', style: TextStyle(color: Colors.black)),
    ),
    const Tab(
      child: Text('Albums', style: TextStyle(color: Colors.black)),
    ),
  ];

  TabController? controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: myTabs.length);
  }
}

class Tracklist extends StatelessWidget {
  const Tracklist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyTabController _tabx = Get.put(MyTabController());

    return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: TabBar(
                  indicator: DotIndicator(
                    color: Colors.blueGrey,
                    distanceFromCenter: 16,
                    radius: 3,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  controller: _tabx.controller,
                  tabs: _tabx.myTabs,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: TabBarView(
        controller: _tabx.controller,
        children: _tabx.myTabs.map((Tab tab) {
          return Container(
            height: MediaQuery.of(context).size.height - 200,
            child: TabBarView(
                controller: _tabx.controller,
                children: [
                  Container(
                    child: const Track(),
                  ),
                  Container(child: const Albums()),
                ],
            ),
          );
        }).toList(),
      ),
              ),
            ],
          )
    );
  }
}

