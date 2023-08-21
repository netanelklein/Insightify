import 'package:flutter/material.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import '../widgets/top_lists/search_bar.dart';
import '../widgets/top_lists/artist_tile.dart';
import '../utils/database_helper.dart';

class TopArtists extends StatefulWidget {
  const TopArtists({super.key});

  @override
  State<TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<TopArtists> {
  final topArtists = DatabaseHelper().getTopArtists();

  @override
  Widget build(BuildContext context) {
    // ItemScrollController itemScrollController = ItemScrollController();

    return FutureBuilder(
      future: topArtists,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            // itemScrollController: itemScrollController,
            itemBuilder: (BuildContext context, int index) {
              return ArtistTile(
                  key: Key("artistTile${snapshot.data![index]['artist_name']}"),
                  artistName: snapshot.data![index]['artist_name'],
                  index: index,
                  timePlayed: snapshot.data![index]['total_ms_played']);
            },
            itemCount: snapshot.data!.length,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
