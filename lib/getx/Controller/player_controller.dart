import 'package:get/get.dart';

class PlayerController extends GetxController {
  var argumentData = List.empty(growable: true).obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   argumentData.clear();
  //   argumentData.addAll(Get.arguments);
  // }
  PlayerController() {
  argumentData.clear();  
  }

  getData(List arguments) async {
    
    argumentData(arguments);
    update();
    return argumentData;
  }
}
