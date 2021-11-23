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
    List mdata = musics.get('tracks');
    searchedList.clear();
    for (var i = 0; i < mdata.length; i++) {
      //starts with
      if (mdata[i]['title'].toLowerCase().startsWith(searchKey.toLowerCase())) {
        searchedList.add(mdata[i]);
      }
      // if (mdata[i]['title'].toLowerCase().contains(searchKey.toLowerCase())) {
      //   searchedList.add(mdata[i]);
      // }
    }
    await Future.delayed(Duration(milliseconds: 5000));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchKey = TextEditingController();

    return Form(
        child: Column(children: [
      const SizedBox(height: 20),
      Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchKey,
                decoration: InputDecoration(
                  labelText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () async {
                List searchedMusic = await searchMusic(searchKey.text);
                setState(() {
                  searchedList = searchedMusic;
                });
              },
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(300, 30)),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchedList.length,
            itemBuilder: (BuildContext context, int index) {
              return searchedList.isEmpty
                  // ignore: avoid_unnecessary_containers
                  ? Container(
                      child: const Center(
                        child: Text('No Results Found'),
                      ),
                    )
                  : ListTile(
                      title: Text(
                        searchedList[index]['title'],
                      ),
                      subtitle: Text(
                        searchedList[index]['artist'],
                      ),
                      leading: QueryArtworkWidget(
                        id: searchedList[index]['id'],
                        type: ArtworkType.AUDIO,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrentMusic(
                              musicList: searchedList,
                              currentIndex: index,
                            ),
                          ),
                        );
                      });
            }),
      )
    ]));
  }
}

Future<List> searchMusic(String searchKey) async {
  List musicList = [];
  var musics = await Hive.openBox('musicBox');
  List mdata = musics.get('tracks');
  musicList.clear();
  for (var i = 0; i < mdata.length; i++) {
    if (mdata[i]['title'].toLowerCase().contains(searchKey.toLowerCase())) {
      musicList.add(mdata[i]);
    }
  }
  return musicList;
}
