import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_state.dart';
import '../../utils/database_helper.dart';

class ClearData extends StatelessWidget {
  const ClearData({Key? key});

  @override
  Widget build(BuildContext context) {
    Future<void> clearPersonalData() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Clear Personal Data'),
            content: Text(
                'Are you sure you want to clear your personal data? This will remove all your saved data from the app.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              Consumer<AppState>(builder: (context, appState, _) {
                return TextButton(
                  onPressed: () async {
                    await DatabaseHelper().deleteData();
                    appState.dataProgress = 0;
                    appState.dataLength = 0;
                    appState.setLoading = false;
                    appState.setDataReady = false;
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Clear'),
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
            title: Text('Clear All Data'),
            content: Text(
                'Are you sure you want to clear all data? This will remove all your saved data from the app, Including your personal data and artists and albums metadata.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              Consumer<AppState>(builder: (context, appState, _) {
                return TextButton(
                  onPressed: () async {
                    await DatabaseHelper().deleteDatabase();
                    await DatabaseHelper.initDatabase();
                    appState.dataProgress = 0;
                    appState.dataLength = 0;
                    appState.setLoading = false;
                    appState.setDataReady = false;
                    Navigator.pop(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Clear'),
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
        SizedBox(height: 10),
        Text('Clear your personal data from the app:'),
        ElevatedButton(
          onPressed: clearPersonalData,
          child: Text('Clear Personal Data'),
        ),
        SizedBox(height: 10),
        Text('Clear all data from the app:'),
        ElevatedButton(
          onPressed: clearAllData,
          child: Text('Clear All Data'),
        ),
      ],
    );
  }
}
