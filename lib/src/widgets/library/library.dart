import 'package:flutter/material.dart';
import '../../models/history.dart';
import 'expanded_artist_tile.dart';

class Library extends StatelessWidget {
  const Library({Key? key, required History history})
      : _history = history,
        super(key: key);

  final History _history;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 500,
        width: 500,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _history.artists.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpandedArtistTile(artist: _history.artists[index]);
          },
        ),
      ),
    );
  }
}
