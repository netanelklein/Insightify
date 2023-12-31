import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_state.dart';
import '../../screens/top_albums.dart';
import '../../screens/top_artists.dart';
import '../../screens/top_tracks.dart';

class TopLists extends StatelessWidget {
  const TopLists({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person_outline),
                iconMargin: EdgeInsets.all(0),
                text: 'Artists',
                height: 50,
              ),
              Tab(
                icon: Icon(Icons.album_outlined),
                iconMargin: EdgeInsets.all(0),
                text: 'Albums',
                height: 50,
              ),
              Tab(
                icon: Icon(Icons.music_note_outlined),
                iconMargin: EdgeInsets.all(0),
                text: 'Tracks',
                height: 50,
              ),
            ],
          ),
        ),
        body: Consumer<AppState>(builder: (context, state, _) {
          return const TabBarView(children: [
            TopArtists(),
            TopAlbums(),
            TopTracks(),
          ]);
        }),
      ),
    );
  }
}
