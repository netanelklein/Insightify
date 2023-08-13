import 'package:flutter/material.dart';
import 'package:insightify/src/utils/database_helper.dart';
import 'package:insightify/src/widgets/top_lists/album_tile.dart';

import '../utils/functions.dart';
import '../widgets/top_lists/track_tile.dart';

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
    final totalTimePlayed = DatabaseHelper().getTotalTimePlayed();
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: Future.wait([topAlbums, topTracks, totalTimePlayed]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 2,
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text('$artistName'),
                          pinned: true,
                        ),
                        SliverToBoxAdapter(
                          child: Card(
                            child: ListTile(
                              title: const Text('Total Time Played:'),
                              subtitle: Center(
                                  child: Text(
                                      '${msToTimeString(timePlayed)}. This is ${((timePlayed / snapshot.data![2][0]['total_ms_played']) * 100).toStringAsFixed(2)}% of your total streaming time.')),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: TabBar(
                            tabs: [
                              Tab(
                                text: 'Top Albums',
                              ),
                              Tab(
                                text: 'Top Tracks',
                              ),
                            ],
                          ),
                        )
                      ];
                    },
                    body: TabBarView(children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return AlbumTile(
                            index: index,
                            albumName: snapshot.data![0][index]['album_name'],
                            artistName: artistName,
                            timePlayed: snapshot.data![0][index]
                                ['total_ms_played'],
                            isTopList: false,
                          );
                        },
                        itemCount: snapshot.data![0].length,
                      ),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return TrackTile(
                            index: index,
                            trackName: snapshot.data![1][index]['track_name'],
                            albumName: snapshot.data![1][index]['album_name'],
                            artistName: artistName,
                            timePlayed: snapshot.data![1][index]
                                ['total_ms_played'],
                            timesPlayed: snapshot.data![1][index]
                                ['times_played'],
                            timesSkipped: snapshot.data![1][index]
                                ['times_skipped'],
                            isTopList: false,
                          );
                        },
                        itemCount: snapshot.data![1].length,
                      )
                    ])),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }
}


/*
DefaultTabController(
                length: 2,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text('$artistName'),

                      pinned: true,
                      floating: true,
                      snap: true,
                      // expandedHeight: 200,
                      bottom: TabBar(
                        tabs: [
                          Tab(
                            text: 'Top Albums',
                          ),
                          Tab(
                            text: 'Top Tracks',
                          ),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: const Text('Total Time Played:'),
                              subtitle: Center(
                                  child: Text(
                                      '${msToTimeString(timePlayed)}. This is ${((timePlayed / snapshot.data![2][0]['total_ms_played']) * 100).toStringAsFixed(2)}% of your total streaming time.')),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
*/