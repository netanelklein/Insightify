import 'package:flutter/material.dart';
import '../../models/track.dart';

class ExpandedTrackTile extends StatefulWidget {
  const ExpandedTrackTile({Key? key, required this.track}) : super(key: key);
  final Track track;

  @override
  State<ExpandedTrackTile> createState() => _ExpandedtrackTileState();
}

class _ExpandedtrackTileState extends State<ExpandedTrackTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.track.title),
      children: [
        Text(widget.track.toString()),
      ],
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = value;
        });
      },
    );
  }
}
