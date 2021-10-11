import 'package:flutter/material.dart';
import 'package:music_player/main.dart';
import 'package:music_player/tabs/tracks.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  List<String> trackTitle = [
    'On My Way',
    'Believer',
    'Bad Liar',
    'Shape of You',
    'The Middle',
    'The Greatest',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {
              const HomePage();
            },
            child: Container(
                child: GridView(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                    children: List.generate(
                        trackTitle.length, (index) => _buildTrack(index)))),
          )
        ]),
      )),
    );
  }
}

_buildTrack(int index) {
  List<String> trackTitle = [
    'On My Way',
    'Believer',
    'Bad Liar',
    'Shape of You',
    'The Middle',
    'The Greatest',
  ];
  List<String> trackArtist = [
    'Ed Sheeran',
    'Ed Sheeran',
    'Ed Sheeran',
    'Ed Sheeran',
    'Ed Sheeran',
    'Ed Sheeran',
  ];

  return Container(
    child: Column(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: const BoxDecoration(
            //shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/image1.jpg'),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          trackTitle[index],
          style: const TextStyle(
            fontFamily: 'Khyay',
            fontSize: 15.0,
            color: Color(0xFF3A6878),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          trackArtist[index],
          style: const TextStyle(
            fontFamily: 'Khyay',
            fontSize: 15.0,
            color: Color(0xFF3A6878),
          ),
        ),
        const Divider(
          height: 5,
        )
      ],
    ),
  );
}
