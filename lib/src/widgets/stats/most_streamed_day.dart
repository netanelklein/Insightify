import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/database_helper.dart';
import '../../utils/functions.dart';
import '../history/history_tile.dart';

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
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          title: const Text('Most Streamed Day:'),
          subtitle: Text(
              'The most streamed day was ${DateFormat.yMd().format(DateTime.parse(date))}.\nYou played ${msToTimeString(msPlayed)} on this day.'),
          onTap: () => showHistory(context, DateTime.parse(date)),
        ));
  }

  Future<dynamic> showHistory(BuildContext context, DateTime date) {
    final history = DatabaseHelper()
        .getStreamingHistoryByDay(false, DateTimeRange(start: date, end: date));
    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    const Text('Most Streamed Day History',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),
                    FutureBuilder(
                        future: history,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final day = snapshot.data!.keys.toList()[0];
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data![day]!.length,
                                itemBuilder: (context, index) {
                                  return HistoryTile(
                                      entry: snapshot.data![day]![index]);
                                },
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              ));
        });
  }
}
