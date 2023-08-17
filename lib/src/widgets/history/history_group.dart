import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../widgets/history/history_tile.dart';
import '../../models/stream_history.dart';
import '../../utils/functions.dart';

class HistoryGroup extends MultiSliver {
  HistoryGroup({super.key, required this.group, required this.day})
      : super(pushPinnedChildren: true, children: [
          SliverPinnedHeader(
            child: DayBar(
              title: getDayString(day),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => HistoryTile(entry: group[index]),
              childCount: group.length,
            ),
          ),
        ]);

  final List<StreamHistoryDBEntry> group;
  final DateTime day;
}

class DayBar extends StatelessWidget {
  const DayBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 100,
      ),
      margin: EdgeInsets.fromLTRB(50, 10, 50, 0),
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
