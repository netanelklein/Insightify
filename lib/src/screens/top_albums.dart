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
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: topAlbums,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No albums found'));
            }
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
                        child: AlbumTile(
                            artistName: snapshot.data![index]['artist_name'],
                            albumName: snapshot.data![index]['album_name'],
                            timePlayed: snapshot.data![index]
                                ['total_ms_played'],
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
