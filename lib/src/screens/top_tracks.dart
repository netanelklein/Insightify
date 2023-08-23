import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../utils/database_helper.dart';
import '../widgets/top_lists/track_tile.dart';

class TopTracks extends StatefulWidget {
  const TopTracks({super.key});

  @override
  State<TopTracks> createState() => _TopTracksState();
}

class _TopTracksState extends State<TopTracks> {
  @override
  Widget build(BuildContext context) {
    final timeRange = Provider.of<AppState>(context).getTimeRange;
    final orderBy = Provider.of<AppState>(context).getListsSort;
    final topTracks = DatabaseHelper().getTopTracks(timeRange, orderBy);
    return FutureBuilder(
        future: topTracks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No tracks found'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return TrackTile(
                    key: Key(
                        "trackTile${snapshot.data![index]['track_name']}_${snapshot.data![index]['artist_name']}"),
                    artistName: snapshot.data![index]['artist_name'],
                    albumName: snapshot.data![index]['album_name'],
                    trackName: snapshot.data![index]['track_name'],
                    timePlayed: snapshot.data![index]['total_ms_played'],
                    timesPlayed: snapshot.data![index]['times_played'],
                    timesSkipped: snapshot.data![index]['times_skipped'],
                    index: index,
                    isTopList: true);
              },
              itemCount: snapshot.data!.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
