import 'package:hive/hive.dart';
part 'favorites_model.g.dart';

@HiveType(typeId: 2)
class FavoritesModel extends HiveObject {
  @HiveField(2)
  late List favoritesData;
}
