import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../widgets/history/history_group.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final streamingHistory = DatabaseHelper().getStreamingHistory();

  final streamingHistoryByDay = DatabaseHelper().getStreamingHistoryByDay();

  int fromIndex = 0;
  int toIndex = 3;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: streamingHistoryByDay,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final keys = snapshot.data!.keys.toList();
            List<String> shownKeys = keys.sublist(fromIndex, toIndex);

            return Builder(builder: (context) {
              final _controller = PrimaryScrollController.of(context);
              _controller.addListener(() {
                if (_controller.position.pixels ==
                    _controller.position.maxScrollExtent) {
                  setState(() {
                    toIndex += 1;
                    shownKeys = keys.sublist(fromIndex, toIndex);
                  });
                }
              });

              return Scrollbar(
                thumbVisibility: true,
                controller: _controller,
                radius: const Radius.circular(10),
                child: CustomScrollView(
                    controller: _controller,
                    slivers: shownKeys
                        .map((day) => HistoryGroup(
                            group: snapshot.data![day]!,
                            day: DateTime.parse(day)))
                        .toList()),
              );
            });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
