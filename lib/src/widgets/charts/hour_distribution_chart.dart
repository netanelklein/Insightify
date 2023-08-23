import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/functions.dart';

class HourDistributionChart extends StatefulWidget {
  const HourDistributionChart({super.key, required this.hoursOfDay});

  final List<Map<String, dynamic>> hoursOfDay;

  @override
  State<HourDistributionChart> createState() => _HourDistributionChartState();
}

class _HourDistributionChartState extends State<HourDistributionChart> {
  bool _morningFirst = true;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> fromMorningToNight = [
      ...widget.hoursOfDay.sublist(6),
      ...widget.hoursOfDay.sublist(0, 6)
    ];

    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Time Spent Listening by Hour',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(
              height: 16,
            ),
            AspectRatio(
              aspectRatio: 1.6,
              child: Stack(
                children: [
                  BarChart(
                    BarChartData(
                      barTouchData: _barTouchData(context),
                      titlesData: _titlesData(),
                      maxY: fromMorningToNight.reduce((curr, next) =>
                              curr['total_ms_played'] > next['total_ms_played']
                                  ? curr
                                  : next)['total_ms_played'] +
                          1000.0,
                      alignment: BarChartAlignment.spaceAround,
                      gridData: const FlGridData(
                        show: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: [
                        for (var hour in _morningFirst
                            ? fromMorningToNight
                            : widget.hoursOfDay)
                          BarChartGroupData(
                            x: int.parse(hour['hour']),
                            barRods: [
                              BarChartRodData(
                                width: 7,
                                toY: hour['total_ms_played'].toDouble(),
                                color: Theme.of(context).colorScheme.primary,
                                // gradient: LinearGradient(
                                //   colors: [
                                //     Theme.of(context).colorScheme.primary,
                                //     Theme.of(context).colorScheme.onTertiary,
                                //   ],
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                // ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 250),
                    swapAnimationCurve: Curves.easeInOut,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        tooltip: _morningFirst
                            ? 'Show Night First'
                            : 'Show Morning First',
                        icon: _morningFirst
                            ? const Icon(Icons.nights_stay)
                            : const Icon(Icons.sunny),
                        onPressed: () {
                          setState(() {
                            _morningFirst = !_morningFirst;
                          });
                        },
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value.toInt() % 2 == 0) {
              return Text(value.toInt().toString().padLeft(2, '0'));
            } else {
              return const SizedBox();
            }
          },
        )));
  }

  BarTouchData _barTouchData(BuildContext context) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Theme.of(context).colorScheme.primary,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            '${group.x.toString().padLeft(2, '0')}:00 - ${(group.x < 23 ? ((group.x) + 1) : 0).toString().padLeft(2, '0')}:00:\n${msToTimeStringShort(rod.toY.toInt())}',
            TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
