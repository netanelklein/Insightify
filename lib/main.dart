import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'src/screens/welcome.dart';

import 'src/utils/database_helper.dart';
import 'src/screens/loading_screen.dart';
import 'src/widgets/navigation/root_navigation.dart';
import 'src/styles/color_schemes.g.dart';
import 'app_state.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppState>(context).isAppReady) {
      FlutterNativeSplash.remove();
    }
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
      ],
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
