import 'package:flutter/material.dart';
import '../../models/album.dart';
import 'expanded_track_tile.dart';

class ExpandedAlbumTile extends StatefulWidget {
  const ExpandedAlbumTile({Key? key, required this.album}) : super(key: key);
  final Album album;

  @override
  State<ExpandedAlbumTile> createState() => _ExpandedAlbumTileState();
}

class _ExpandedAlbumTileState extends State<ExpandedAlbumTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.album.name),
      children: [
        for (var track in widget.album.tracks) ExpandedTrackTile(track: track),
      ],
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
    );
  }
}
