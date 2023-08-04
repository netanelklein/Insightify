import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/stats.dart';
import '../../screens/top_albums.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screens/top_artists.dart';
import '../../screens/top_tracks.dart';
import '../../../app_state.dart';
import 'bottom_navigator.dart';
import '../../utils/database_helper.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _selectedIndex = 0;
  double _minTime = 0;

  void setSelecteIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _minTime = context.watch<AppState>().minTime.toDouble();
    return Scaffold(
      appBar: AppBar(elevation: 2, title: const Text('Insightify'), actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            showSettingsModal(context);
          },
        ),
      ]),
      body: <Widget>[
        Stats(),
        const TopArtists(),
        const TopAlbums(),
        const TopTracks()
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigator(
        selectedIndex: _selectedIndex,
        onChange: setSelecteIndex,
      ),
    );
  }

  Future<dynamic> showSettingsModal(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 700,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('Settings', style: TextStyle(fontSize: 20)),
                    const Divider(),
                    Slider(
                        value: _minTime,
                        max: 60,
                        divisions: 1,
                        label: _minTime.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _minTime = value;
                          });
                        }),
                    FilledButton(
                        onPressed: openClearDataDialog(),
                        child: const Text('Clear Data')),
                    const Text(
                        'This app is still in development. If you have any suggestions or feedback, please email me at:'),
                    // const SizedBox(height: 5),
                    TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse(
                              'mailto:netanel@netanelk.com?subject=Spotify%20Data%20Analyzer%20Feedback'));
                        },
                        child: const Text('netanel@netanelk.com'))
                  ],
                ),
              ),
            ),
          );
        });
  }

  openClearDataDialog() {
    return () {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Clear Data'),
                content: const Text(
                    'Are you sure you want to clear all data? This action cannot be undone.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  Consumer<AppState>(
                    builder: (context, appState, _) => TextButton(
                        onPressed: () async {
                          await DatabaseHelper().deleteData();
                          appState.dataProgress = 0;
                          appState.dataLength = 0;
                          appState.setLoading = false;
                          appState.setDataReady = false;
                          Navigator.pop(context);
                        },
                        child: const Text('Clear Data')),
                  )
                ],
              ));
    };
  }
}
