import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_state.dart';
import '../utils/database_helper.dart';
import '../utils/error_reporting.dart';
import '../utils/input_validator.dart';

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
          // Check if it's a partial match for extended data
          final commonExtendedKeys = [
            'ts',
            'master_metadata_track_name',
            'master_metadata_album_artist_name',
            'ms_played'
          ];
          final commonNonExtendedKeys = [
            'endTime',
            'trackName',
            'artistName',
            'msPlayed'
          ];

          if (entry.keys.toSet().containsAll(commonExtendedKeys)) {
            type = 'extended';
          } else if (entry.keys.toSet().containsAll(commonNonExtendedKeys)) {
            type = 'non-extended';
          } else {
            type = 'unknown';
            return type;
          }
        }
      } else {
        // For subsequent entries, just check the core required keys
        if (type == 'extended') {
          final coreKeys = ['ts', 'master_metadata_track_name', 'ms_played'];
          if (!entry.keys.toSet().containsAll(coreKeys)) {
            return 'unknown';
          }
        } else if (type == 'non-extended') {
          final coreKeys = ['endTime', 'trackName', 'msPlayed'];
          if (!entry.keys.toSet().containsAll(coreKeys)) {
            return 'unknown';
          }
        }
      }
    }
    return type;
  }

  void _uploadData(BuildContext context, AppState state) async {
    final errorReporting = ErrorReportingService();

    try {
      errorReporting.info('Starting file upload process');

      final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json'],
          allowMultiple: true);

      if (result != null) {
        state.setLoading = true;

        List<dynamic> data = [];
        List<String> errorMessages = [];

        for (var file in result.files) {
          try {
            if (file.path == null) {
              final errorMsg = 'File ${file.name}: Path is null';
              errorMessages.add(errorMsg);
              errorReporting.fileError(errorMsg, file.name);
              continue;
            }

            errorReporting.debug('Processing file: ${file.name}',
                context: {'filePath': file.path});
            final fileContents = File(file.path!).readAsStringSync();

            // Validate JSON structure before parsing
            if (!InputValidator.validateJsonStructure(fileContents)) {
              final errorMsg =
                  'File ${file.name}: Invalid or potentially unsafe JSON structure';
              errorMessages.add(errorMsg);
              errorReporting.fileError(errorMsg, file.name);
              continue;
            }

            final contents = InputValidator.safeJsonParse(fileContents);
            if (contents == null) {
              final errorMsg = 'File ${file.name}: Failed to parse JSON safely';
              errorMessages.add(errorMsg);
              errorReporting.fileError(errorMsg, file.name);
              continue;
            }

            if (contents is List<dynamic>) {
              final type = _getDataType(contents);

              if (type == 'extended' || type == 'non-extended') {
                data.addAll(contents);
                errorReporting.info('Successfully processed file: ${file.name}',
                    context: {
                      'recordCount': contents.length,
                      'dataType': type
                    });
              } else {
                final errorMsg =
                    'File ${file.name}: Unsupported data format ($type)';
                errorMessages.add(errorMsg);
                errorReporting.fileError(errorMsg, file.name);
              }
            } else {
              final errorMsg = 'File ${file.name}: Content is not a JSON array';
              errorMessages.add(errorMsg);
              errorReporting.fileError(errorMsg, file.name);
            }
          } catch (e, stackTrace) {
            final errorMsg = 'File ${file.name}: Error processing - $e';
            errorMessages.add(errorMsg);
            errorReporting.fileError(errorMsg, file.name,
                error: e, stackTrace: stackTrace);
          }
        }

        if (data.isNotEmpty) {
          try {
            errorReporting.info(
                'Attempting to insert ${data.length} records into database');
            final result = await DatabaseHelper().insertDataBatch(data);
            if (result > 0) {
              state.timeRange = await DatabaseHelper().getMaxDateRange();
              state.setLoading = false;
              state.setDataReady = true;
              errorReporting.info('Successfully inserted data into database');
            } else {
              state.setLoading = false;
              errorReporting.databaseError(
                  'Failed to insert data into database',
                  operation: 'insertDataBatch');
              _showErrorDialog(context, 'Failed to insert data into database');
            }
          } catch (e, stackTrace) {
            state.setLoading = false;
            errorReporting.databaseError('Database error during insertion',
                error: e, stackTrace: stackTrace, operation: 'insertDataBatch');
            _showErrorDialog(context, 'Database error: $e');
          }
        } else {
          state.setLoading = false;
          String errorMsg = 'No valid data was found in the selected files.';
          if (errorMessages.isNotEmpty) {
            errorMsg += '\n\nErrors:\n${errorMessages.join('\n')}';
          }
          errorReporting.warning('No valid data found in uploaded files',
              context: {'errorCount': errorMessages.length});
          _showErrorDialog(context, errorMsg);
        }
      }
    } catch (e, stackTrace) {
      state.setLoading = false;
      errorReporting.critical('Unexpected error during file upload',
          error: e,
          stackTrace: stackTrace,
          category: ErrorCategory.fileProcessing);
      _showErrorDialog(context, 'Unexpected error: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                      onPressed: () => _uploadData(context, appState),
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
