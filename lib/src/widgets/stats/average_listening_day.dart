import 'package:flutter/material.dart';

import '../../utils/functions.dart';

class AverageListeningDay extends StatelessWidget {
  const AverageListeningDay({
    super.key,
    required this.averageMsPlayed,
  });

  final int averageMsPlayed;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: const Text('Your Average Listening Day:'),
      subtitle: Text(
          'You listen to music for ${msToTimeString(averageMsPlayed)} on your average day.'),
    ));
  }
}
