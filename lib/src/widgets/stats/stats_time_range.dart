import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_state.dart';
import '../../utils/database_helper.dart';

class StatsTimeRange extends StatelessWidget {
  const StatsTimeRange({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Time Frame:', style: TextStyle(fontSize: 20)),
          Text(
              'The shown statistics are from ${DateFormat.yMd().format(appState.timeRange.start)} to ${DateFormat.yMd().format(appState.timeRange.end)}.'),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
                onPressed: () {
                  DatabaseHelper().getMaxDateRange().then((value) {
                    appState.setTimeRange = value;
                    appState.setIsMaxRange = true;
                  });
                },
                child: const Text('Show All Time Statistics')),
          )
        ]),
      ),
    );
  }
}
