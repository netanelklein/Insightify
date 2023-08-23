import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/stats/average_listening_day.dart';
import '../widgets/stats/favourite_time_of_day.dart';
import '../widgets/stats/most_streamed_day.dart';
import '../widgets/stats/stats_time_range.dart';
import '../widgets/stats/total_play_time.dart';
import '../utils/database_helper.dart';
import '../../app_state.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    final timeRange = Provider.of<AppState>(context).timeRange;
    final totalPlayedTime = DatabaseHelper().getTotalTimePlayed(timeRange);
    final mostStreamedDay = DatabaseHelper().getMostPlayedDay(timeRange);
    final averageListeningDay = DatabaseHelper().getAverageDay(timeRange);
    final timeOfDay = DatabaseHelper().getTimeOfDay(timeRange);

    return FutureBuilder(
      future: Future.wait(
          [totalPlayedTime, mostStreamedDay, averageListeningDay, timeOfDay]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data![0][0]['total_ms_played'] == null) {
            return const Center(child: Text('No data found'));
          }
          return Consumer<AppState>(builder: (context, appState, _) {
            return ListView(
              children: [
                !appState.isMaxRange
                    ? StatsTimeRange(appState: appState)
                    : Container(),
                TotalPlayTime(
                    msPlayed: snapshot.data![0][0]['total_ms_played']),
                MostStreamedDay(
                    date: snapshot.data![1][0]['day'],
                    msPlayed: snapshot.data![1][0]['total_ms_played']),
                AverageListeningDay(
                    averageMsPlayed: snapshot.data![2][0]['average_ms_played']),
                FavouriteTimeOfDay(hoursOfDay: snapshot.data![3]),
              ],
            );
          });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
