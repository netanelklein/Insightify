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
        data.addAll(contents);
      }
      await DatabaseHelper().insertDataBatch(data);
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
            DecoratedBox(
              decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onBackground
                        : Colors.transparent,
                    Colors.transparent
                  ], stops: [
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.upload_file),
                          const SizedBox(width: 5),
                          const Text('Upload Data'),
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
