import 'package:flutter/material.dart';

import '../../widgets/history/history_tile.dart';
import '../../models/stream_history.dart';
import '../../utils/functions.dart';

class HistoryGroup extends StatelessWidget {
  const HistoryGroup({super.key, required this.group, required this.day});

  final List<StreamHistoryDBEntry> group;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    // TODO: implement sticky headers

    return Column(
      children: [
        AppBar(
          title: Text(getDayString(day)),
        ),
        Column(
          children: group
              .map((e) => HistoryTile(
                    entry: e,
                  ))
              .toList(),
        )
      ],
    );
  }
}
