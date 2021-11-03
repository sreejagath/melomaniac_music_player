import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<SharedPreferences>(
            future: prefs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                notification = snapshot.data?.getBool('notification') ?? true;
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: Text('Notification'),
                      leading: const Icon(Icons.notifications),
                      trailing: Switch(
                        value: notification,
                        onChanged: (value) {
                          setState(() {
                            notification = value;
                          });
                          snapshot.data?.setBool('notification', value);
                        },
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
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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
