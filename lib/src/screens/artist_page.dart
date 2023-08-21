import 'package:flutter/material.dart';
import 'package:insightify/app_state.dart';
import 'package:insightify/src/utils/database_helper.dart';
import 'package:insightify/src/widgets/top_lists/album_tile.dart';
import 'package:provider/provider.dart';

import '../utils/functions.dart';
import '../widgets/top_lists/track_tile.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage(
      {super.key, required this.artistName, required this.timePlayed});
  final String artistName;
  final int timePlayed;

  @override
  Widget build(BuildContext context) {
    final timeRange = Provider.of<AppState>(context).getTimeRange;
    final topAlbums = DatabaseHelper().getTopAlbums(timeRange, artistName);
    final topTracks = DatabaseHelper().getTopTracks(timeRange, artistName);
    final totalTimePlayed = DatabaseHelper().getTotalTimePlayed(timeRange);
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: Future.wait([topAlbums, topTracks, totalTimePlayed]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: snapshot.data![0].isNotEmpty ? 2 : 1,
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text(artistName),
                          floating: true,
                          forceElevated: innerBoxIsScrolled,
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
                      ];
                    },
                    body: Scaffold(
                      appBar: AppBar(
                          automaticallyImplyLeading: false,
                          title: snapshot.data![0].isNotEmpty
                              ? const TabBar(
                                  tabs: [
                                    Tab(
                                      text: 'Top Albums',
                                    ),
                                    Tab(
                                      text: 'Top Tracks',
                                    ),
                                  ],
                                )
                              : const TabBar(
                                  tabs: [
                                    Tab(
                                      text: 'Top Tracks',
                                    ),
                                  ],
                                )),
                      body: snapshot.data![0].isNotEmpty
                          ? TabBarView(children: [
                              ListView.builder(
                                itemBuilder: (context, index) {
                                  return AlbumTile(
                                    index: index,
                                    albumName: snapshot.data![0][index]
                                        ['album_name'],
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
                                    trackName: snapshot.data![1][index]
                                        ['track_name'],
                                    albumName: snapshot.data![1][index]
                                        ['album_name'],
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
                            ])
                          : TabBarView(children: [
                              ListView.builder(
                                itemBuilder: (context, index) {
                                  return TrackTile(
                                    index: index,
                                    trackName: snapshot.data![1][index]
                                        ['track_name'],
                                    albumName: snapshot.data![1][index]
                                        ['album_name'],
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
                            ]),
                    )),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    ));
  }
}
