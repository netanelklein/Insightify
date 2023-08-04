import 'package:flutter/material.dart';
import '../models/history.dart';
import 'package:fl_chart/fl_chart.dart';

class ArtistChart extends StatelessWidget {
  const ArtistChart({Key? key, required History history})
      : _history = history,
        super(key: key);
  final History _history;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Text('Artist Chart'),
          SizedBox(
            height: 300,
            width: 500,
            child: PieChart(
              PieChartData(
                sections: [
                  for (var artist in _history.artists)
                    PieChartSectionData(
                      value: artist.timePlayed.toDouble(),
                      title: artist.name,
                      showTitle:
                          _history.artists.indexOf(artist) < 25 ? true : false,
                      color: Colors.primaries[_history.artists.indexOf(artist) %
                          Colors.primaries.length],
                      radius: 100,
                      titlePositionPercentageOffset: 1,
                      badgePositionPercentageOffset: 0,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
