import 'package:flutter/material.dart';
import 'package:insightify/app_state.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    // ItemScrollController itemScrollController = ItemScrollController();
    final timeRange = Provider.of<AppState>(context).getTimeRange;
    final topArtists = DatabaseHelper().getTopArtists(timeRange);

    return FutureBuilder(
      future: topArtists,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No artists found'));
          }
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
