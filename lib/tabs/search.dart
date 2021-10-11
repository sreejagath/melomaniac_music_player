import 'package:flutter/material.dart';

class SearchTrack extends StatefulWidget {
  const SearchTrack({Key? key}) : super(key: key);

  @override
  _SearchTrackState createState() => _SearchTrackState();
}

class _SearchTrackState extends State<SearchTrack> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          child: Column(children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Search...',
              // labelStyle: TextStyle(
              //   color: Colors.black,
              // // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.black),),
              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(10),
                
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
