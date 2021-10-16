import 'package:flutter/material.dart';
import 'package:music_player/tabs/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchTrack extends StatefulWidget {
  const SearchTrack({Key? key}) : super(key: key);

  @override
  _SearchTrackState createState() => _SearchTrackState();
}

class _SearchTrackState extends State<SearchTrack> {
  OnAudioQuery _audioQuery = OnAudioQuery();
  List<dynamic> musicList = [];

  bool textKeyActive = false;

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
            //onChanged: searchTracks,
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
        ElevatedButton(
            onPressed: () async {
              List<dynamic> songs = await _audioQuery.queryWithFilters(
                searchKey.text,
                WithFiltersType.AUDIOS,
              );
              // print(musicList);
              setState(() {
                musicList = songs;
              });
              
              print(musicList);
            },
            child: Text('Search')),
        Column(
          children: [
            searchKey.text.isEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: musicList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            // leading: CircleAvatar(
                            //   radius: 25,
                            //   backgroundImage: AssetImage(music[index]['image']),
                            // ),
                            title: Text(
                              musicList[index]['title'],
                              style: const TextStyle(
                                fontFamily: 'Genera',
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              musicList[index]['artist'],
                              style: const TextStyle(
                                fontFamily: 'Genera',
                                fontSize: 15.0,
                                color: Color(0xFF3A6878),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CurrentMusic(
                                            musicList: musicList,
                                          )));
                            },
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 10,
                          ),
                        ],
                      );
                    },
                  )
                : FutureBuilder<List<SongModel>>(
                    // Default values:
                    future: _audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true,
                    ),
                    builder: (context, item) {
                      // Loading content
                      if (item.data == null)
                        return const CircularProgressIndicator();
                      if (item.data!.isEmpty)
                        return const Text('Nothing found!');
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: item.data!.length,
                        itemBuilder: (context, index) {
                          List data = [
                            {
                              'title': item.data![index].title,
                              'artist': item.data![index].artist,
                              'uri': item.data![index].uri,
                              'id': item.data![index].id,
                              'asset': 'false'
                            }
                          ];
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                ListTile(
                                    title: Text(
                                      item.data![index].title,
                                      style: const TextStyle(
                                        fontFamily: 'Genera',
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.data![index].artist ?? "No Artist",
                                      style: const TextStyle(
                                        fontFamily: 'Genera',
                                        fontSize: 15.0,
                                        color: Color(0xFF3A6878),
                                      ),
                                    ),
                                    trailing:
                                        const Icon(Icons.arrow_forward_rounded),
                                    leading: QueryArtworkWidget(
                                      id: item.data![index].id,
                                      type: ArtworkType.AUDIO,
                                    ),
                                    //onTap: openPage(data),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CurrentMusic(
                                                      musicList: data)));
                                      print(data);
                                    }),
                                const Divider(
                                  color: Colors.black,
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ],
        )
      ])),
    );
  }
}
