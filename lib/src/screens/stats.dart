import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/functions.dart';
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
    return FutureBuilder(
      future:
          Future.wait([totalPlayedTime, mostStreamedDay, averageListeningDay]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data![0][0]['total_ms_played'] == null) {
            return const Center(child: Text('No data found'));
          }
          return Consumer<AppState>(builder: (context, appState, _) {
            return Column(
              children: [
                !appState.isMaxRange
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Time Frame:',
                                    style: TextStyle(fontSize: 20)),
                                Text(
                                    'The shown statistics are from ${DateFormat.yMd().format(appState.timeRange.start)} to ${DateFormat.yMd().format(appState.timeRange.end)}.'),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FilledButton(
                                      onPressed: () {
                                        DatabaseHelper()
                                            .getMaxDateRange()
                                            .then((value) {
                                          appState.setTimeRange = value;
                                          appState.setIsMaxRange = true;
                                        });
                                      },
                                      child: const Text(
                                          'Show All Time Statistics')),
                                )
                              ]),
                        ),
                      )
                    : Container(),
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
          });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
