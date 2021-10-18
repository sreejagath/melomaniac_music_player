import 'package:hive/hive.dart';
part 'playlist_model.g.dart';

@HiveType(typeId: 1)
class PlaylistModel extends HiveObject {
  @HiveField(1)
  late List playlistData;
}
