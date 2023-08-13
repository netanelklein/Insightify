import 'package:flutter/material.dart';
import '../utils/functions.dart';
import '../utils/database_helper.dart';

class Stats extends StatelessWidget {
  Stats({super.key});

  final totalPlayedTime = DatabaseHelper().getTotalTimePlayed();
  final mostStreamedDay = DatabaseHelper().getMostPlayedDay();
  final averageListeningDay = DatabaseHelper().getAverageDay();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Future.wait([totalPlayedTime, mostStreamedDay, averageListeningDay]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Card(
                child: ListTile(
                  title: const Text('Total Time Played:'),
                  subtitle: Center(
                      child: Text(msToTimeString(
                          snapshot.data![0][0]['total_ms_played']))),
                ),
              ),
              Card(
                  child: ListTile(
                title: const Text('Most Streamed Day:'),
                subtitle: Text(
                    'The most streamed day was ${snapshot.data![1][0]['day']}.\nYou played ${msToTimeString(snapshot.data![1][0]['total_ms_played'])} on this day.'),
              )),
              Card(
                  child: ListTile(
                title: const Text('Your Average Listening Day:'),
                subtitle: Text(
                    'You listen to music for ${msToTimeString(snapshot.data![2][0]['average_ms_played'])} on your average day.'),
              )),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
