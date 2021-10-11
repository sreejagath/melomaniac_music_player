import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    //List view of settings
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 20,
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications),
                trailing: Switch(
                  onChanged: (value) => setState(() {
                    _switchValue = value;
                  }),
                  value: _switchValue,
                ),
              ),
              const ListTile(
                title: Text('Share'),
                leading: Icon(Icons.share),
              ),
              const ListTile(
                title: Text('About'),
                leading: Icon(Icons.notes),
              ),
              const ListTile(
                title: Text('Terms & Conditions'),
                leading: Icon(Icons.book),
              ),
              const ListTile(
                title: Text('Privacy Policies'),
                leading: Icon(Icons.bookmark),
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
                'Version 1.3',
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
