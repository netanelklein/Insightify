import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../widgets/track_tile.dart';

class TopTracks extends StatefulWidget {
  const TopTracks({super.key});

  @override
  State<TopTracks> createState() => _TopTracksState();
}

class _TopTracksState extends State<TopTracks> {
  final topTracks = DatabaseHelper().getTopTracks();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: topTracks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    TrackTile(
                        artistName: snapshot.data![index]['artist_name'],
                        albumName: snapshot.data![index]['album_name'],
                        trackName: snapshot.data![index]['track_name'],
                        timePlayed: snapshot.data![index]['total_ms_played'],
                        timesSkipped: snapshot.data![index]['times_skipped'],
                        index: index),
                    const Divider(
                      height: 0,
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                  ],
                );
              },
              childCount: snapshot.data!.length,
            ));
          } else {
            return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}