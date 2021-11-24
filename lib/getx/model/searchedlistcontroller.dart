import 'package:get/get.dart';
import 'searchlist.dart';
import 'package:hive/hive.dart';

class SearchedData extends GetxController {

  var searchList = List.empty(growable: true).obs;

  getSearch(String query) async {
    //List musicList = [];
    var musics = await Hive.openBox('musicBox');
    List mdata = musics.get('tracks');

    searchList.clear();
    for (var i = 0; i < mdata.length; i++) {
      if (mdata[i]['title'].toLowerCase().startsWith(query.toLowerCase())) {
        searchList.add(mdata[i]);
      }
    }
    return searchList;
  }
}
