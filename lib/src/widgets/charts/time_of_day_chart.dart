import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class TimeOfDayChart extends StatefulWidget {
  const TimeOfDayChart({
    super.key,
    required this.timeOfDay,
    required this.totalMsPlayed,
  });

  final Map<String, num> timeOfDay;
  final int totalMsPlayed;

  @override
  State<TimeOfDayChart> createState() => _TimeOfDayChartState();
}

class _TimeOfDayChartState extends State<TimeOfDayChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Time of Day Listening Distribution',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onTertiaryContainer)),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Indicator(
                      color: Colors.primaries[0],
                      text: 'Morning',
                      isSquare: false,
                      size: touchedIndex == 0 ? 18 : 16,
                      textColor: touchedIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                    Indicator(
                      color: Colors.primaries[1],
                      text: 'Afternoon',
                      isSquare: false,
                      size: touchedIndex == 1 ? 18 : 16,
                      textColor: touchedIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Indicator(
                        color: Colors.primaries[2],
                        text: 'Evening',
                        isSquare: false,
                        size: touchedIndex == 2 ? 18 : 16,
                        textColor: touchedIndex == 2
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground,
                      ),
                      Indicator(
                        color: Colors.primaries[3],
                        text: 'Night',
                        isSquare: false,
                        size: touchedIndex == 3 ? 18 : 16,
                        textColor: touchedIndex == 3
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground,
                      ),
                    ]),
              ],
            ),
            // const SizedBox(
            //   height: 64,
            // ),
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          // touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    }),
                    sections: showSections(),
                    centerSpaceRadius: 40,
                    borderData: FlBorderData(show: false)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showSections() {
    return List.generate(4, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      const List<Shadow> shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.primaries[0],
            value: widget.timeOfDay['morning']! / widget.totalMsPlayed * 100,
            title:
                '${(widget.timeOfDay['morning']! / widget.totalMsPlayed * 100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                shadows: shadows),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.primaries[1],
            value: widget.timeOfDay['afternoon']! / widget.totalMsPlayed * 100,
            title:
                '${(widget.timeOfDay['afternoon']! / widget.totalMsPlayed * 100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                shadows: shadows),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.primaries[2],
            value: widget.timeOfDay['evening']! / widget.totalMsPlayed * 100,
            title:
                '${(widget.timeOfDay['evening']! / widget.totalMsPlayed * 100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                shadows: shadows),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.primaries[3],
            value: widget.timeOfDay['night']! / widget.totalMsPlayed * 100,
            title:
                '${(widget.timeOfDay['night']! / widget.totalMsPlayed * 100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                shadows: shadows),
          );
        default:
          throw Error();
      }
    });
  }
}
