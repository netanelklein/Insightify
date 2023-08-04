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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: topTracks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(10),
                interactive: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: TrackTile(
                            artistName: snapshot.data![index]['artist_name'],
                            albumName: snapshot.data![index]['album_name'],
                            trackName: snapshot.data![index]['track_name'],
                            timePlayed: snapshot.data![index]
                                ['total_ms_played'],
                            timesSkipped: snapshot.data![index]
                                ['times_skipped'],
                            index: index));
                  },
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
