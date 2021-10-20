import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class MusicModel extends HiveObject {
  @HiveField(0)
  late List? musicData;
}
