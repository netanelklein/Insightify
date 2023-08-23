import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:insightify/src/utils/functions.dart';

class FavouriteTimeOfDay extends StatelessWidget {
  const FavouriteTimeOfDay({
    super.key,
    required this.hoursOfDay,
  });

  final List<Map<String, dynamic>> hoursOfDay;

  @override
  Widget build(BuildContext context) {
    final Map<String, num> timeOfDay = {
      'morning': hoursOfDay
          .where((element) =>
              int.parse(element['hour']) >= 6 &&
              int.parse(element['hour']) < 12)
          .fold(0, (previousValue, element) {
        return previousValue + element['total_ms_played'];
      }),
      'afternoon': hoursOfDay
          .where((element) =>
              int.parse(element['hour']) >= 12 &&
              int.parse(element['hour']) < 18)
          .fold(0, (previousValue, element) {
        return previousValue + element['total_ms_played'];
      }),
      'evening': hoursOfDay
          .where((element) =>
              int.parse(element['hour']) >= 18 &&
              int.parse(element['hour']) < 21)
          .fold(0, (previousValue, element) {
        return previousValue + element['total_ms_played'];
      }),
      'night': hoursOfDay
          .where((element) =>
              int.parse(element['hour']) >= 21 ||
              int.parse(element['hour']) < 6)
          .fold(0, (previousValue, element) {
        return previousValue + element['total_ms_played'];
      }),
    };

    final String favouriteTimeOfDay = timeOfDay.entries
        .reduce((curr, next) => curr.value > next.value ? curr : next)
        .key
        .capitalize();

    final int msPlayed = timeOfDay.entries
        .reduce((curr, next) => curr.value > next.value ? curr : next)
        .value
        .toInt();

    final int totalMsPlayed = timeOfDay.values.reduce((a, b) => a + b).toInt();

    return Card(
        child: ListTile(
      title: const Text('Your Favourite Time of Day:'),
      subtitle: Text('You listen to music mostly in the $favouriteTimeOfDay.\n'
          'You have listened to music for ${msToTimeString(msPlayed)} in this time of day.\n'
          'This is ${(msPlayed / totalMsPlayed * 100).toStringAsFixed(2)}% of your total listening time.'),
    ));
  }
}
