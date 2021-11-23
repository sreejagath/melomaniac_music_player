import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  RxBool notification = true.obs;
  toggleNotification() {
    notification.value = !notification.value;
  }
}
