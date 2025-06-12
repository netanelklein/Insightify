import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/screens/loading_screen.dart';
import 'src/screens/welcome.dart';
import 'src/styles/color_schemes.g.dart';
import 'src/utils/database_helper.dart';
import 'src/utils/error_reporting.dart';
import 'src/widgets/navigation/root_navigation.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize error reporting and global error handling
  final errorReporting = ErrorReportingService();
  errorReporting.setupGlobalErrorHandling();
  errorReporting.info('Application starting up');

  try {
    await DatabaseHelper.initDatabase();
    errorReporting.info('Database initialized successfully');
  } catch (e, stackTrace) {
    errorReporting.critical('Failed to initialize database', 
        error: e, stackTrace: stackTrace, category: ErrorCategory.database);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final MaterialTheme theme = const MaterialTheme(TextTheme());

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
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: Consumer<AppState>(
          builder: (context, appState, _) => appState.dataReady
              ? const RootNavigation()
              : appState.loading
                  ? const LoadingScreen()
                  : const WelcomeScreen()),
    );
  }
}
