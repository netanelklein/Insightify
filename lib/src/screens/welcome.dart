import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/database_helper.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../../app_state.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  String _getDataType(List<dynamic> data) {
    String type = '';
    final List<String> extendedDataKeys = [
      'ts',
      'username',
      'platform',
      'ms_played',
      'conn_country',
      'ip_addr_decrypted',
      'user_agent_decrypted',
      'master_metadata_track_name',
      'master_metadata_album_artist_name',
      'master_metadata_album_album_name',
      'spotify_track_uri',
      'episode_name',
      'episode_show_name',
      'spotify_episode_uri',
      'reason_start',
      'reason_end',
      'shuffle',
      'skipped',
      'offline',
      'offline_timestamp',
      'incognito_mode'
    ];

    final List<String> nonExtendedDataKeys = [
      'endTime',
      'artistName',
      'trackName',
      'msPlayed',
    ];
    for (var entry in data) {
      // first item
      if (type == '') {
        if (entry.keys.toSet().containsAll(extendedDataKeys)) {
          type = 'extended';
        } else if (entry.keys.toSet().containsAll(nonExtendedDataKeys)) {
          type = 'non-extended';
        } else {
          type = 'unknown';
          return type;
        }
      } else {
        if (type == 'extended' &&
            !entry.keys.toSet().containsAll(extendedDataKeys)) {
          return 'unknown';
        } else if (type == 'non-extended' &&
            !entry.keys.toSet().containsAll(nonExtendedDataKeys)) {
          return 'unknown';
        }
      }
    }
    return type;
  }

  void _uploadData(AppState state) async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: true);
    if (result != null) {
      state.setLoading = true;

      List<dynamic> data = [];
      for (var file in result.files) {
        final contents = jsonDecode(File(file.path!).readAsStringSync());
        if (contents is List<dynamic>) {
          final type = _getDataType(contents);
          if (type == 'extended' || type == 'non-extended') {
            data.addAll(contents);
          }
        }
      }
      await DatabaseHelper().insertDataBatch(data);
      state.timeRange = await DatabaseHelper().getMaxDateRange();
      state.setLoading = false;
      state.setDataReady = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                style: TextStyle(fontFamily: 'DancingScript', fontSize: 30)),
          ],
        ),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Insightify!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please upload your Spotify data to get started',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Consumer<AppState>(
                  builder: (context, appState, _) => FilledButton(
                      key: const Key('uploadDataButton'),
                      onPressed: () => _uploadData(appState),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload_file),
                          SizedBox(width: 5),
                          Text('Upload Data'),
                        ],
                      ))),
              TextButton(
                  key: const Key('uploadHelpButton'),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title:
                                const Text('What files do I need to upload?'),
                            content: const Text(
                                'It depends on the type of the data you chose to download.\n\nIf you have chosen to download your account data, you will need to upload all of the files named "StreamingHistoryX.json" where X is a number.\n\nIf you have chosen to download your extended streaming history, you will need to upload all of the files named "Streaming_History_Audio_Y_X.json" where Y is a year or a span of years and X is a number.'),
                            actions: [
                              TextButton(
                                  key: const Key('helpOkButton'),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Got it!'))
                            ],
                          )),
                  child: const Text(
                    'What files do I need to upload?',
                    style: TextStyle(fontSize: 15),
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.help_outline,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      'This app analyzes your Spotify data to give you insights into your listening habits.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have your data? You can ask for it ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse(
                        "https://www.spotify.com/us/account/privacy/")),
                    child: Text(
                      'here',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      'Tip: You can choose between Account data and Extended streaming history. Extended streaming history gives you more detailed data, but it takes longer to process.',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
