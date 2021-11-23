import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/getx/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  //Constructor
  @override
  //Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  // bool notification = true;

  @override
  Widget build(BuildContext context) {
    final notifications = Get.put(NotificationController());
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // FutureBuilder<SharedPreferences>(
          //   future: prefs,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       notification = snapshot.data?.getBool('notification') ?? true;
          //       return ;
          //     } else {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                title: Text('Notification'),
                leading: const Icon(Icons.notifications),
                // trailing: Switch(
                //   value: notification,
                //   onChanged: (value) {
                //     setState(() {
                //       notification = value;
                //     });
                //     snapshot.data?.setBool('notification', value);
                //   },
                // ),
                trailing: GetBuilder<NotificationController>(
                  builder: (_) => Switch(
                    value: notifications.notify,
                    onChanged: (value) {
                      notifications.toggleNotify(value);
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text('Share'),
                leading: Icon(Icons.share),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'This feature is not availiable now.Will be implemented in next update !')));
                },
              ),
              ListTile(
                title: Text('Terms & Conditions'),
                leading: Icon(Icons.book),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'This feature is not availiable now.Will be implemented in next update !')));
                },
              ),
              ListTile(
                title: Text('Privacy Policies'),
                leading: Icon(Icons.bookmark),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'This feature is not availiable now.Will be implemented in next update !')));
                },
              ),
              ListTile(
                title: Text('About'),
                leading: Icon(Icons.notes),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Melomaniac',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2021 Melomaniac',
                    applicationIcon: Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
