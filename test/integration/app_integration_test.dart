import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:insightify/app_state.dart';
import 'package:insightify/main.dart';
import 'package:insightify/src/utils/input_validator.dart';

void main() {
  group('Input Validation Integration Tests', () {
    test('should validate JSON structure before processing', () {
      // Test valid JSON structure validation
      const validJson = '''
      [
        {
          "ts": "2024-01-01T00:00:00Z",
          "master_metadata_track_name": "Test Song",
          "master_metadata_album_artist_name": "Test Artist",
          "ms_played": 30000
        }
      ]
      ''';

      expect(InputValidator.validateJsonStructure(validJson), isTrue);

      final parsed = InputValidator.safeJsonParse(validJson);
      expect(parsed, isA<List<dynamic>>());
      expect(parsed[0]['master_metadata_track_name'], equals('Test Song'));
    });

    test('should reject malicious JSON', () {
      // Test JSON with excessive nesting
      String maliciousJson = '';
      for (int i = 0; i < 110; i++) {
        maliciousJson += '{"nested":';
      }
      maliciousJson += '"value"';
      for (int i = 0; i < 110; i++) {
        maliciousJson += '}';
      }

      expect(InputValidator.validateJsonStructure(maliciousJson), isFalse);
      expect(InputValidator.safeJsonParse(maliciousJson), isNull);
    });

    test('should sanitize search input', () {
      // Test search input sanitization
      expect(InputValidator.sanitizeSearchQuery('The Beatles'),
          equals('The Beatles'));
      expect(InputValidator.sanitizeSearchQuery('Song\x00\x1F\x7F'),
          equals('Song'));
      expect(InputValidator.sanitizeSearchQuery(''), isNull);
      expect(InputValidator.sanitizeSearchQuery('   '), isNull);

      // Test length limitation
      final longString = 'a' * 600;
      final sanitized = InputValidator.sanitizeSearchQuery(longString);
      expect(sanitized?.length, equals(InputValidator.maxSearchLength));
    });

    test('should validate music names for API calls', () {
      // Test music name validation
      expect(InputValidator.sanitizeMusicName('The Beatles'),
          equals('The Beatles'));
      expect(InputValidator.sanitizeMusicName('Björk'), equals('Björk'));
      expect(InputValidator.sanitizeMusicName(''), isNull);
      expect(InputValidator.sanitizeMusicName(null), isNull);

      // Test length rejection
      final tooLong = 'a' * 1100;
      expect(InputValidator.sanitizeMusicName(tooLong), isNull);
    });

    test('should validate file paths securely', () {
      // Test file path validation
      expect(InputValidator.sanitizeFilePath('file.json', ['json']),
          equals('file.json'));
      expect(InputValidator.sanitizeFilePath('file.txt', ['json']), isNull);
      expect(
          InputValidator.sanitizeFilePath('../../../etc/passwd.json', ['json']),
          equals('etc/passwd.json'));
    });

    test('should validate URLs properly', () {
      // Test URL validation
      expect(InputValidator.isValidUrl('https://api.spotify.com/v1/tracks'),
          isTrue);
      expect(InputValidator.isValidUrl('http://example.com'), isTrue);
      expect(InputValidator.isValidUrl('ftp://example.com'), isFalse);
      expect(InputValidator.isValidUrl('javascript:alert("xss")'), isFalse);
      expect(InputValidator.isValidUrl('not-a-url'), isFalse);
    });

    test('should handle numeric range validation', () {
      // Test numeric range validation
      expect(InputValidator.isValidNumericRange(50, 0, 100), isTrue);
      expect(InputValidator.isValidNumericRange(0, 0, 100), isTrue);
      expect(InputValidator.isValidNumericRange(100, 0, 100), isTrue);
      expect(InputValidator.isValidNumericRange(-1, 0, 100), isFalse);
      expect(InputValidator.isValidNumericRange(101, 0, 100), isFalse);
      expect(InputValidator.isValidNumericRange(null, 0, 100), isFalse);
    });

    test('should sanitize display text', () {
      // Test display text sanitization
      expect(InputValidator.sanitizeForDisplay('Hello, World!'),
          equals('Hello, World!'));
      expect(InputValidator.sanitizeForDisplay('Text\x00\x08\x0B\x0C'),
          equals('Text'));
      expect(InputValidator.sanitizeForDisplay(null), equals(''));
    });
  });

  group('App Initialization Widget Tests', () {
    testWidgets('app should start without crashing',
        (WidgetTester tester) async {
      final appState = AppState(skipInit: true);

      // Don't call init() to avoid access token loading issues in tests
      appState.appReady = true;
      appState.dataReady = false;

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MyApp(),
        ),
      );
      await tester.pump(); // Single pump to avoid triggering async operations

      // Verify the app starts successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle state changes', (WidgetTester tester) async {
      final appState = AppState(skipInit: true);

      // Set up test state manually
      appState.appReady = true;
      appState.dataReady = false;

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MyApp(),
        ),
      );

      // Initially should not be loading and not ready
      expect(appState.loading, isFalse);
      expect(appState.dataReady, isFalse);

      // Set loading state
      appState.setLoading = true;
      await tester.pump();

      expect(appState.loading, isTrue);
    });
  });
}
