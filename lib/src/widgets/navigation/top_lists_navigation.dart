import 'package:flutter/material.dart';
import 'package:insightify/src/screens/top_albums.dart';
import 'package:insightify/src/screens/top_artists.dart';
import 'package:insightify/src/screens/top_tracks.dart';

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
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            TabBarView(children: [TopArtists(), TopAlbums(), TopTracks()]),
            // BottomSearchBar()
          ],
        ),
      ),
    );
  }
}

class BottomSearchBar extends StatelessWidget {
  const BottomSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none),
              filled: true,
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              constraints: BoxConstraints(maxHeight: 55),
            ),
          )),
          IconButton(
              onPressed: () => print('TODO: Implement sort functionality'),
              icon: Icon(Icons.sort))
        ],
      ),
    );
  }
}
