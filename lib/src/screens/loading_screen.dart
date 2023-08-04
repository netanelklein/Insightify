import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_analyzer/app_state.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            const Text('Getting your data ready...'),
            const SizedBox(
              height: 20,
            ),
            Consumer<AppState>(
                builder: (context, appState, _) => Column(
                      children: [
                        LinearProgressIndicator(
                          value: appState.dataProgress / appState.dataLength,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                                '${appState.dataProgress}/${appState.dataLength}'),
                            const Spacer(),
                            Text(
                                '${(appState.dataProgress / appState.dataLength * 100).toInt()} %'),
                          ],
                        ),
                      ],
                    )),
            const SizedBox(height: 20),
            const Text('This may take a while, please be patient.'),
          ],
        ),
      ),
    );
  }
}
