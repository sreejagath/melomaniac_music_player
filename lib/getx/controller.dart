import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  var notify = true;
  final storage = GetStorage();
  NotificationController() {
    if (storage.read('notify') != null) {
      storage.read('notify');
    }
    else {
      storage.write('notify', true);
    }
  }
  toggleNotify(bool value) {
    notify = value;
    storage.write('notify', notify);
    update();
  }
}
