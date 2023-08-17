import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/navigation/top_lists_navigation.dart';
import '../../screens/settings.dart';
import '../../screens/stats.dart';
import '../../screens/history.dart';
import 'package:url_launcher/url_launcher.dart';
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
                    DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: RadialGradient(colors: [
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.onBackground
                                : Colors.transparent,
                            Colors.transparent
                          ], stops: const [
                            0.95,
                            1
                          ]),
                          color: Colors.white),
                      child: Image.asset(
                        'assets/icons/ChalkLogoR.png',
                        height: 40,
                      ),
                    ),
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
                                          text: 'netanel@netanelk.com',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(Uri.parse(
                                                  'mailto:netanel@netanlk.com?subject=Insightify%20Feedback'));
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
            Stats(),
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
