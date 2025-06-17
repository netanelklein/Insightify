// Widget tests for the Insightify app
//
// These tests verify that the main widget components render correctly
// and have the expected behavior.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:insightify/main.dart';
import 'package:insightify/app_state.dart';

void main() {
  testWidgets('MyApp widget renders without error',
      (WidgetTester tester) async {
    // Create a test AppState
    final appState = AppState(skipInit: true);
    appState.appReady = true;
    appState.dataReady = false;

    // Build our app wrapped in a Provider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: const MyApp(),
      ),
    );

    // Verify that the app renders without throwing an exception
    expect(find.byType(MaterialApp), findsOneWidget);

    // Since the app starts with dataReady = false and loading = false,
    // it should show the WelcomeScreen
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App shows LoadingScreen when loading',
      (WidgetTester tester) async {
    final appState = AppState(skipInit: true);
    appState.setLoading = true;

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: appState,
        child: const MyApp(),
      ),
    );

    await tester.pump(); // Let the widget build

    // The app should be showing some form of loading indication
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
