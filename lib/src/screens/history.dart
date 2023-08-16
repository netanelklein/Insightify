import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../widgets/history/history_group.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final streamingHistory = DatabaseHelper().getStreamingHistory();
  final streamingHistoryByDay = DatabaseHelper().getStreamingHistoryByDay();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: streamingHistoryByDay,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final keys = snapshot.data!.keys.toList();

            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return HistoryGroup(
                      group: snapshot.data![keys[index]]!,
                      day: DateTime.parse(keys[index]));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
