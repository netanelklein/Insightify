import 'package:flutter/material.dart';
import '../widgets/artist_tile.dart';
import '../utils/database_helper.dart';

class TopArtists extends StatefulWidget {
  const TopArtists({Key? key}) : super(key: key);

  @override
  State<TopArtists> createState() => _TopArtistsState();
}

class _TopArtistsState extends State<TopArtists> {
  final topArtists = DatabaseHelper().getTopArtists();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: topArtists,
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
                      child: ArtistTile(
                          artistName: snapshot.data![index]['artist_name'],
                          index: index,
                          timePlayed: snapshot.data![index]
                              ['total_ms_played']));
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
