import 'package:flutter/material.dart';
import 'package:insightify/src/utils/functions.dart';

class TotalPlayTime extends StatelessWidget {
  const TotalPlayTime({
    super.key,
    required this.msPlayed,
  });

  final int msPlayed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Total Time Played:'),
        subtitle: Center(child: Text(msToTimeString(msPlayed))),
      ),
    );
  }
}
