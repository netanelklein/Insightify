import 'package:flutter/material.dart';
import '../widgets/album_tile.dart';
import '../utils/database_helper.dart';

class TopAlbums extends StatefulWidget {
  const TopAlbums({super.key});

  @override
  State<TopAlbums> createState() => _TopAlbumsState();
}

class _TopAlbumsState extends State<TopAlbums> {
  final topAlbums = DatabaseHelper().getTopAlbums();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: topAlbums,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No albums found'));
            }
            return SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    AlbumTile(
                        artistName: snapshot.data![index]['artist_name'],
                        albumName: snapshot.data![index]['album_name'],
                        timePlayed: snapshot.data![index]['total_ms_played'],
                        index: index),
                  ],
                );
              },
              childCount: snapshot.data!.length,
            ));
          } else {
            return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
