import 'package:flutter/material.dart';
import 'package:insightify/app_state.dart';
import 'package:provider/provider.dart';

import '../utils/database_helper.dart';
import '../utils/functions.dart';
import '../widgets/top_lists/track_tile.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage(
      {super.key,
      required this.artistName,
      required this.albumName,
      required this.timePlayed});

  final String artistName;
  final String albumName;
  final int timePlayed;

  @override
  Widget build(BuildContext context) {
    final timeRange = Provider.of<AppState>(context).getTimeRange;
    final orderBy = Provider.of<AppState>(context).getListsSort;
    final topTracks = DatabaseHelper()
        .getTopTracks(timeRange, orderBy, artistName, albumName);
    final totalTimePlayed = DatabaseHelper().getTotalTimePlayed(timeRange);

    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: Future.wait([topTracks, totalTimePlayed]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DefaultTabController(
                length: 1,
                child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text(albumName),
                          floating: true,
                          forceElevated: innerBoxIsScrolled,
                        ),
                        SliverToBoxAdapter(
                          child: Card(
                            child: ListTile(
                              title: const Text('Total Time Played:'),
                              subtitle: Center(
                                  child: Text(
                                      '${msToTimeString(timePlayed)}. This is ${((timePlayed / snapshot.data![1][0]['total_ms_played']) * 100).toStringAsFixed(2)}% of your total streaming time.')),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        title: const TabBar(
                          tabs: [
                            Tab(
                              text: 'Top Tracks',
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(children: [
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return TrackTile(
                              index: index,
                              trackName: snapshot.data![0][index]['track_name'],
                              albumName: albumName,
                              artistName: artistName,
                              timePlayed: snapshot.data![0][index]
                                  ['total_ms_played'],
                              timesPlayed: snapshot.data![0][index]
                                  ['times_played'],
                              timesSkipped: snapshot.data![0][index]
                                  ['times_skipped'],
                              isTopList: false,
                            );
                          },
                          itemCount: snapshot.data![0].length,
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
