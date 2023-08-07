import 'package:flutter/material.dart';
import '../widgets/top_lists/artist_tile.dart';
import '../utils/database_helper.dart';

class TopArtists extends StatefulWidget {
  const TopArtists({Key? key}) : super(key: key);

  @override
  State<TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<TopArtists> {
  final topArtists = DatabaseHelper().getTopArtists();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: topArtists,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: [
                  ArtistTile(
                      artistName: snapshot.data![index]['artist_name'],
                      index: index,
                      timePlayed: snapshot.data![index]['total_ms_played']),
                ],
              );
            },
            childCount: snapshot.data!.length,
          ));
        } else {
          return const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
