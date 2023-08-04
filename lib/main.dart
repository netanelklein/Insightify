import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_analyzer/src/screens/welcome.dart';

import 'src/utils/database_helper.dart';
import 'src/screens/loading_screen.dart';
import 'package:spotify_analyzer/src/widgets/navigation/root_navigation.dart';
import 'src/styles/color_schemes.g.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.initDatabase();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: Consumer<AppState>(
          builder: (context, appState, _) => appState.dataReady
              ? const RootNavigation()
              : appState.loading
                  ? const LoadingScreen()
                  : const WelcomeScreen()),
    );
  }
}
