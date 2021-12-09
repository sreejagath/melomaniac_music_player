import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/getx/Controller/controller.dart';
import 'package:share_plus/share_plus.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final notifications = Get.put(NotificationController());
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: const Text('Notification'),
                leading: const Icon(Icons.notifications),
                trailing: GetBuilder<NotificationController>(
                  builder: (_) => Switch(
                    activeColor: Colors.blueGrey,
                    value: notifications.notify,
                    onChanged: (value) {
                      notifications.toggleNotify(value);
                    },
                  ),
                ),
              ),
              ListTile(
                title: const Text('Share'),
                leading: const Icon(Icons.share),
                onTap: () {
                  Share.share('Check out \'Melomaniac\' https://play.google.com/store/apps/details?id=com.melomaniac.musicplayer');
                },
              ),
              ListTile(
                title: const Text('About'),
                leading: const Icon(Icons.notes),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Melomaniac',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2021 Melomaniac',
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 220,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Version 1.0.1',
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
