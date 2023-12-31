import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../utils/database_helper.dart';
import '../widgets/top_lists/album_tile.dart';

class TopAlbums extends StatefulWidget {
  const TopAlbums({super.key});

  @override
  State<TopAlbums> createState() => _TopAlbumsState();
}

class _TopAlbumsState extends State<TopAlbums> {
  @override
  Widget build(BuildContext context) {
    final timeRange = Provider.of<AppState>(context).getTimeRange;
    final orderBy = Provider.of<AppState>(context).getListsSort;
    final topAlbums = DatabaseHelper().getTopAlbums(timeRange, orderBy);
    return FutureBuilder(
        future: topAlbums,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No albums found'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return AlbumTile(
                  key: Key(
                      "albumTile${snapshot.data![index]['album_name']}_${snapshot.data![index]['artist_name']}"),
                  artistName: snapshot.data![index]['artist_name'],
                  albumName: snapshot.data![index]['album_name'],
                  timePlayed: snapshot.data![index]['total_ms_played'],
                  index: index,
                  isTopList: true,
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
