import 'package:flutter/material.dart';
import '../../models/artist.dart';
import 'expanded_album_tile.dart';

class ExpandedArtistTile extends StatefulWidget {
  const ExpandedArtistTile({Key? key, required this.artist}) : super(key: key);
  final Artist artist;

  @override
  State<ExpandedArtistTile> createState() => _ExpandedArtistTileState();
}

class _ExpandedArtistTileState extends State<ExpandedArtistTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.artist.name),
      children: [
        for (var album in widget.artist.albums) ExpandedAlbumTile(album: album),
      ],
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
    );
  }
}
