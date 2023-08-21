import 'package:flutter/material.dart';
import 'package:insightify/app_state.dart';
import 'package:provider/provider.dart';
import '../utils/database_helper.dart';
import '../widgets/history/history_group.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int fromIndex = 0;
  int toIndex = 3;
  bool descending = true;

  @override
  Widget build(BuildContext context) {
    final timeRange = Provider.of<AppState>(context).timeRange;
    final streamingHistoryByDay =
        DatabaseHelper().getStreamingHistoryByDay(descending, timeRange);
    return FutureBuilder(
        future: streamingHistoryByDay,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('No history found'));
            }
            final keys = snapshot.data!.keys.toList();
            if (keys.length < toIndex) {
              toIndex = keys.length;
            }
            List<String> shownKeys = keys.sublist(fromIndex, toIndex);

            return Builder(builder: (context) {
              // final _controller = PrimaryScrollController.of(context);
              final controller = ScrollController();
              controller.addListener(() {
                if (controller.position.pixels ==
                    controller.position.maxScrollExtent) {
                  setState(() {
                    if (toIndex < keys.length) {
                      toIndex += 1;
                      shownKeys = keys.sublist(fromIndex, toIndex);
                    }
                  });
                }
              });

              return Scrollbar(
                interactive: true,
                thumbVisibility: true,
                controller: controller,
                radius: const Radius.circular(500),
                child: Stack(
                  children: [
                    CustomScrollView(
                        controller: controller,
                        slivers: shownKeys
                            .map((day) => HistoryGroup(
                                group: snapshot.data![day]!,
                                day: DateTime.parse(day)))
                            .toList()),
                    Positioned(
                        top: 10,
                        right: 0,
                        child: PopupMenuButton(
                          icon: const Icon(Icons.sort),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'desc',
                              child: Row(children: [
                                Radio(
                                    value: true,
                                    groupValue: descending,
                                    onChanged: (_) {}),
                                const Text('Newest first')
                              ]),
                            ),
                            PopupMenuItem(
                              value: 'asc',
                              child: Row(children: [
                                Radio(
                                    value: false,
                                    groupValue: descending,
                                    onChanged: (_) {}),
                                const Text('Oldest first')
                              ]),
                            ),
                          ],
                          onSelected: (value) {
                            setState(() {
                              descending = value == 'desc' ? true : false;
                              fromIndex = 0;
                              toIndex = 3;
                              if (keys.length < toIndex) {
                                toIndex = keys.length;
                              }
                              shownKeys = keys.sublist(fromIndex, toIndex);
                              controller
                                  .jumpTo(controller.position.minScrollExtent);
                            });
                          },
                        )),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            controller.animateTo(
                                controller.position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                        ))
                  ],
                ),
              );
            });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
