import 'package:flutter/material.dart';
import 'package:insightify/src/utils/database_helper.dart';
import 'package:insightify/src/widgets/top_lists/album_tile.dart';

import '../utils/functions.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage(
      {super.key,
      required this.artistName,
      required this.artistImage,
      required this.timePlayed});
  final String artistName;
  final String artistImage;
  final int timePlayed;

  @override
  Widget build(BuildContext context) {
    final topAlbums = DatabaseHelper().getTopAlbums(artistName);
    final topTracks = DatabaseHelper().getTopTracks(artistName);
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: Future.wait([topAlbums, topTracks]),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('$artistName'),
                  pinned: true,
                  floating: true,
                ),
                snapshot.hasData
                    ? Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: const Text('Total Time Played:'),
                              subtitle: Center(
                                  child: Text(msToTimeString(timePlayed))),
                            ),
                          ),
                          Row(
                            children: [
                              Card(
                                child: const Text('Top Albums'),
                              ),
                              Card(
                                child: const Text('Top Tracks'),
                              )
                            ],
                          ),
                        ],
                      )
                    : SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator())),
              ],
            );
          }),
    ));
  }
}
