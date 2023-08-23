import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_state.dart';
import '../../screens/history.dart';
import '../../screens/settings.dart';
import '../../screens/stats.dart';
import '../../utils/database_helper.dart';
import '../../widgets/history/history_sort.dart';
import '../../widgets/navigation/top_lists_navigation.dart';
import '../../widgets/top_lists/top_lists_sort.dart';
import 'bottom_navigator.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _selectedIndex = 0;

  void setSelecteIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showPicker(DateTimeRange curr, DateTimeRange max, AppState state) async {
    await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      firstDate: max.start,
      lastDate: max.end,
      initialDateRange: curr,
      helpText: 'Select a time range to view your stats.',
    ).then((value) {
      if (value != null) {
        setState(() {
          state.setTimeRange = value;
          if (DateFormat.yMd().format(value.start) ==
                  DateFormat.yMd().format(max.start) &&
              DateFormat.yMd().format(value.end) ==
                  DateFormat.yMd().format(max.end)) {
            state.setIsMaxRange = true;
          } else {
            state.setIsMaxRange = false;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Row(
                  children: [
                    Material(
                        borderRadius: BorderRadius.circular(40),
                        elevation: 1,
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/icons/NewLogoSquare.png',
                          height: 40,
                        )),
                    const SizedBox(width: 10),
                    const Text('Insightify',
                        style: TextStyle(
                            fontFamily: 'DancingScript', fontSize: 30)),
                  ],
                ),
                floating: true,
                scrolledUnderElevation: 0,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  Consumer<AppState>(builder: (context, appState, _) {
                    return IconButton(
                      onPressed: () async {
                        final max = await DatabaseHelper().getMaxDateRange();
                        showPicker(appState.timeRange, max, appState);
                      },
                      icon: appState.getIsMaxRange
                          ? const Icon(Icons.date_range)
                          : const Badge(
                              label: Text('!'), child: Icon(Icons.date_range)),
                      tooltip: 'Time range',
                    );
                  }),
                  _selectedIndex == 1 ? const TopListsSort() : const SizedBox(),
                  _selectedIndex == 2 ? const HistorySort() : const SizedBox(),
                  PopupMenuButton(
                    key: const Key('settings_menu'),
                    onSelected: (value) {
                      switch (value) {
                        case 'settings':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingsScreen()));
                          break;
                        case 'about':
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    key: const Key('about_dialog'),
                                    title: const Text('About'),
                                    content: RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              'Insightify is an app that analyzes your Spotify data and gives you insights about your listening habits.\n\n',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                      TextSpan(
                                          text:
                                              'This app is still in development. If you have any suggestions or feedback, please email me at: ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                      TextSpan(
                                          text: 'insightify@netanelk.com',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(Uri.parse(
                                                  'mailto:insightify@netanlk.com?subject=Insightify%20Feedback'));
                                            }),
                                      TextSpan(
                                          text:
                                              '.\n\nYou can also check out the source code on ',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                      TextSpan(
                                          text: 'GitHub',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(
                                                  Uri.parse(
                                                      'https://github.com/netanelklein/Insightify/tree/main'),
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            }),
                                      TextSpan(
                                          text: '.',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground)),
                                    ])),
                                    actions: [
                                      TextButton(
                                          key: const Key('aboutCloseButton'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close')),
                                    ],
                                  ));
                          break;
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry>[
                      const PopupMenuItem(
                        key: Key('settings_menu_item'),
                        value: 'settings',
                        child: Text('Settings'),
                      ),
                      const PopupMenuItem(
                        key: Key('about_menu_item'),
                        value: 'about',
                        child: Text('About'),
                      ),
                    ],
                  )
                ],
              ),
            ];
          },
          body: <Widget>[
            const Stats(),
            const TopLists(),
            const HistoryScreen()
          ][_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigator(
        selectedIndex: _selectedIndex,
        onChange: setSelecteIndex,
      ),
    );
  }
}
