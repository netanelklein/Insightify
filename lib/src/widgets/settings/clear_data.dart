import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_state.dart';
import '../../utils/database_helper.dart';

class ClearData extends StatelessWidget {
  const ClearData({super.key});

  @override
  Widget build(BuildContext context) {
    popNavigator() {
      Navigator.pop(context);
      Navigator.of(context).pop();
    }

    Future<void> clearPersonalData() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Clear Personal Data'),
            content: const Text(
                'Are you sure you want to clear your personal data? This will remove all your saved data from the app.'),
            actions: [
              TextButton(
                key: const Key('clearPersonalDataCancelButton'),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Consumer<AppState>(builder: (context, appState, _) {
                return TextButton(
                  key: const Key('clearPersonalDataButton'),
                  onPressed: () async {
                    await DatabaseHelper().deleteData();
                    appState.dataProgress = 0;
                    appState.dataLength = 0;
                    appState.setLoading = false;
                    appState.setDataReady = false;
                    popNavigator();
                  },
                  child: const Text('Clear'),
                );
              }),
            ],
          );
        },
      );
    }

    Future<void> clearAllData() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Clear All Data'),
            content: const Text(
                'Are you sure you want to clear all data? This will remove all your saved data from the app, Including your personal data and artists and albums metadata.'),
            actions: [
              TextButton(
                key: const Key('clearAllDataCancelButton'),
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Consumer<AppState>(builder: (context, appState, _) {
                return TextButton(
                  key: const Key('clearAllDataButton'),
                  onPressed: () async {
                    await DatabaseHelper().deleteDatabase();
                    await DatabaseHelper.initDatabase();
                    appState.dataProgress = 0;
                    appState.dataLength = 0;
                    appState.setLoading = false;
                    appState.setDataReady = false;
                    popNavigator();
                  },
                  child: const Text('Clear'),
                );
              })
            ],
          );
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Clear Data', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text('Clear your personal data from the app:'),
        ElevatedButton(
          key: const Key('clearPersonalDataButton'),
          onPressed: clearPersonalData,
          child: const Text('Clear Personal Data'),
        ),
        const SizedBox(height: 10),
        const Text('Clear all data from the app:'),
        ElevatedButton(
          key: const Key('clearAllDataButton'),
          onPressed: clearAllData,
          child: const Text('Clear All Data'),
        ),
      ],
    );
  }
}
