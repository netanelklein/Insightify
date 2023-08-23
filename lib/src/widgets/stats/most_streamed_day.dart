import 'package:flutter/material.dart';

import '../../utils/functions.dart';

class MostStreamedDay extends StatelessWidget {
  const MostStreamedDay({
    super.key,
    required this.date,
    required this.msPlayed,
  });

  final String date;
  final int msPlayed;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: const Text('Most Streamed Day:'),
      subtitle: Text(
          'The most streamed day was $date.\nYou played ${msToTimeString(msPlayed)} on this day.'),
    ));
  }
}
