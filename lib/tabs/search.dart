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
                  primary: Colors.blueGrey,
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
      Obx(
        () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: searchWithGetx.searchList.length,
          itemBuilder: (context, index) {
            return searchWithGetx.searchList == []
                ? const ListTile(
                    title: Text('No Results'),
                  )
                : ListTile(
                    title: Text(
                      searchWithGetx.searchList[index]['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      searchWithGetx.searchList[index]['artist'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: QueryArtworkWidget(
                      id: searchWithGetx.searchList[index]['id'],
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(Player(),
                          arguments: [searchWithGetx.searchList, index]);
                    },
                  );
          },
        ),
      ),
    ]));
  }
}
