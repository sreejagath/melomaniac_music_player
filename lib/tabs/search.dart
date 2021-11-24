import 'package:flutter/material.dart';
import 'package:music_player/getx/model/searchedlistcontroller.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

OnAudioQuery _audioQuery = OnAudioQuery();
List<dynamic> musicList = [];
var searchedList;

bool textKeyActive = false;

class SearchTrack extends StatefulWidget {
  const SearchTrack({Key? key}) : super(key: key);

  @override
  _SearchTrackState createState() => _SearchTrackState();
}

class _SearchTrackState extends State<SearchTrack> {
  @override
  Widget build(BuildContext context) {
    final searchWithGetx = Get.put(SearchedData());
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
                searchedList = await searchWithGetx.getSearch(searchKey.text);
                print(searchedList);
                // List searchedMusic = await searchMusic(searchKey.text);
                // setState(() {
                //   searchedList = searchedMusic;
                // });
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
      //create listview builder with searched list using obx
      Obx(
        () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: searchWithGetx.searchList.length,
          itemBuilder: (context, index) {
            return searchWithGetx.searchList==[]?
            ListTile(
              title: Text('No Results'),
            ):
            ListTile(
              title: Text(searchWithGetx.searchList[index]['title']),
              subtitle: Text(
                        searchWithGetx.searchList[index]['artist'],
                      ),
                      leading: QueryArtworkWidget(
                        id: searchWithGetx.searchList[index]['id'],
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
                // searchWithGetx.addToPlaylist(searchedList[index]);
                // Get.to(Player());
              },
            );
          },
        ),
      ),
      // GetBuilder<SearchedData>(
      //   init: SearchedData(),
      //   builder: (context) => ListView.builder(
      //     shrinkWrap: true,
      //     scrollDirection: Axis.vertical,
      //     itemCount: searchWithGetx.searchList.length,
      //     itemBuilder: (context, index) {
      //       print(searchWithGetx.searchList.length);
      //       return searchedList.length == 0
      //           ? ListTile(
      //               title: Text('No results found'),
      //             )
      //           : ListTile(
      //               leading: Icon(Icons.music_note),
      //               title: Text(searchWithGetx.searchList[index]['title']),
      //               // subtitle: Text(searchedList[index].artist),
      //               onTap: () {
      //                 // searchWithGetx.addToPlaylist(searchedList[index]);
      //                 // Get.to(Player());
      //               },
      //             );
      //     },
      //   ),
      // ),

      // ListView.builder(
      //     shrinkWrap: true,
      //     scrollDirection: Axis.vertical,
      //     itemCount: searchedList.length,
      //     itemBuilder: (BuildContext context, index) {
      //       return ListTile(
      //         title: Text(searchedList[index]['title']),
      //         // subtitle: Text(searchedList[index]['artist']),
      //         // onTap: () {
      //         //   addToPlaylist(searchedList[index]);
      //         //   Get.back();
      //         // },
      //       );
      //     }),
      // Container(
      //   child: ListView.builder(
      //       scrollDirection: Axis.vertical,
      //       physics: NeverScrollableScrollPhysics(),
      //       shrinkWrap: true,
      //       itemCount: searchedList.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         return searchedList.isEmpty
      //             // ignore: avoid_unnecessary_containers
      //             ? Container(
      //                 child: const Center(
      //                   child: Text('No Results Found'),
      //                 ),
      //               )
      //             : ListTile(
      //                 title: Text(
      //                   searchedList[index]['title'],
      //                 ),
      //                 subtitle: Text(
      //                   searchedList[index]['artist'],
      //                 ),
      //                 leading: QueryArtworkWidget(
      //                   id: searchedList[index]['id'],
      //                   type: ArtworkType.AUDIO,
      //                 ),
      //                 onTap: () {
      //                   Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) => CurrentMusic(
      //                         musicList: searchedList,
      //                         currentIndex: index,
      //                       ),
      //                     ),
      //                   );
      //                 });
      //       }),
      // )
    ]));
  }
}

Future<List> searchMusic(String searchKey) async {
  List musicList = [];
  var musics = await Hive.openBox('musicBox');
  List mdata = musics.get('tracks');
  musicList.clear();
  for (var i = 0; i < mdata.length; i++) {
    if (mdata[i]['title'].toLowerCase().startsWith(searchKey.toLowerCase())) {
      musicList.add(mdata[i]);
    }
  }
  return musicList;
}
