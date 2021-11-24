import 'package:flutter/material.dart';
import 'package:music_player/getx/Controller/searchedlistcontroller.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:get/get.dart';

List<dynamic> musicList = [];

bool textKeyActive = false;

class SearchTrack extends StatelessWidget {
  const SearchTrack({Key? key}) : super(key: key);

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
                searchWithGetx.getSearch(searchKey.text);
                
              },
              child: const Text('Search'),
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
            const ListTile(
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
                              musicList: searchWithGetx.searchList,
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
    ]));
  }
}
