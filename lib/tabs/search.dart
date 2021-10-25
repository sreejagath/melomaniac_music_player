import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive/hive.dart';

class SearchTrack extends StatefulWidget {
  const SearchTrack({Key? key}) : super(key: key);

  @override
  _SearchTrackState createState() => _SearchTrackState();
}

class _SearchTrackState extends State<SearchTrack> {
  OnAudioQuery _audioQuery = OnAudioQuery();
  List<dynamic> musicList = [];
  List<dynamic> searchedList = [];

  bool textKeyActive = false;
  Future searchTracks(String searchKey) async {
    var musics = await Hive.openBox('musicBox');
    //print(musics.getAt(0));

    List mdata = musics.getAt(0);
    searchedList.clear();
    for (var i = 0; i < mdata.length; i++) {
      if (mdata[i]['title'].toLowerCase().contains(searchKey.toLowerCase())) {
        searchedList.add(mdata[i]);
      }
    }
    await Future.delayed(Duration(milliseconds: 5000));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchKey = TextEditingController();

    return SingleChildScrollView(
      child: Form(
          child: Column(children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: searchKey,
            onChanged: searchTracks,
            decoration: InputDecoration(
              labelText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: searchedList.length,
            itemBuilder: (BuildContext context, int index) {
              print(searchedList);
              return ListTile(
                  title: Text(
                searchedList[index]['title'],
              ));
            })
      ])),
    );
  }
}
