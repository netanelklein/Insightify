import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../widgets/history/history_group.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int fromIndex = 0;
  int toIndex = 3;
  bool descending = true;

  @override
  Widget build(BuildContext context) {
    final streamingHistoryByDay =
        DatabaseHelper().getStreamingHistoryByDay(descending);
    return FutureBuilder(
        future: streamingHistoryByDay,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            final keys = snapshot.data!.keys.toList();
            List<String> shownKeys = keys.sublist(fromIndex, toIndex);

            return Builder(builder: (context) {
              // final _controller = PrimaryScrollController.of(context);
              final _controller = ScrollController();
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
                interactive: true,
                thumbVisibility: true,
                controller: _controller,
                radius: const Radius.circular(500),
                child: Stack(
                  children: [
                    CustomScrollView(
                        controller: _controller,
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
                              child: Row(children: [
                                Radio(
                                    value: true,
                                    groupValue: descending,
                                    onChanged: (_) {}),
                                Text('Newest first')
                              ]),
                              value: 'desc',
                            ),
                            PopupMenuItem(
                              child: Row(children: [
                                Radio(
                                    value: false,
                                    groupValue: descending,
                                    onChanged: (_) {}),
                                Text('Oldest first')
                              ]),
                              value: 'asc',
                            ),
                          ],
                          onSelected: (value) {
                            setState(() {
                              descending = value == 'desc' ? true : false;
                              fromIndex = 0;
                              toIndex = 3;
                              shownKeys = keys.sublist(fromIndex, toIndex);
                              _controller
                                  .jumpTo(_controller.position.minScrollExtent);
                            });
                          },
                        )),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            _controller.animateTo(
                                _controller.position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          },
                        ))
                  ],
                ),
              );
            });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
