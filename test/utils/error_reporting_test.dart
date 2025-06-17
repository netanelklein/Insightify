import 'package:flutter_test/flutter_test.dart';
import 'package:insightify/src/utils/error_reporting.dart';

void main() {
  group('ErrorReportingService', () {
    late ErrorReportingService errorReporting;

    setUp(() {
      errorReporting = ErrorReportingService();
      errorReporting.clearHistory();
      errorReporting.debugLoggingEnabled =
          false; // Disable console output during tests
    });

    group('Basic Logging', () {
      test('should log debug messages', () {
        errorReporting.debug('Test debug message');

        final errors = errorReporting.getRecentErrors();
        expect(errors.length, equals(1));
        expect(errors[0].level, equals(LogLevel.debug));
        expect(errors[0].message, equals('Test debug message'));
      });

      test('should log info messages', () {
        errorReporting.info('Test info message');

        final errors = errorReporting.getRecentErrors();
        expect(errors.length, equals(1));
        expect(errors[0].level, equals(LogLevel.info));
      });

      test('should log warnings', () {
        errorReporting.warning('Test warning',
            category: ErrorCategory.userInput);

        final errors = errorReporting.getRecentErrors();
        expect(errors.length, equals(1));
        expect(errors[0].level, equals(LogLevel.warning));
        expect(errors[0].category, equals(ErrorCategory.userInput));
      });

      test('should log errors with stack traces', () {
        final exception = Exception('Test exception');
        final stackTrace = StackTrace.current;

        errorReporting.error('Test error',
            error: exception,
            stackTrace: stackTrace,
            category: ErrorCategory.database);

        final errors = errorReporting.getRecentErrors();
        expect(errors.length, equals(1));
        expect(errors[0].level, equals(LogLevel.error));
        expect(errors[0].error, equals(exception));
        expect(errors[0].stackTrace, equals(stackTrace));
        expect(errors[0].category, equals(ErrorCategory.database));
      });

      test('should log critical errors', () {
        errorReporting.critical('Critical system error');

        final errors = errorReporting.getRecentErrors();
        expect(errors.length, equals(1));
        expect(errors[0].level, equals(LogLevel.critical));
      });
    });

    group('Context and Enrichment', () {
      test('should include context in error reports', () {
        final context = {'userId': '123', 'operation': 'file_upload'};
        errorReporting.error('Test error with context', context: context);

        final errors = errorReporting.getRecentErrors();
        expect(errors[0].context, equals(context));
      });

      test('should enrich file errors with file information', () {
        errorReporting.fileError('File processing failed', 'test.json',
            context: {'fileSize': 1024});

        final errors = errorReporting.getRecentErrors();
        expect(errors[0].category, equals(ErrorCategory.fileProcessing));
        expect(errors[0].context['fileName'], equals('test.json'));
        expect(errors[0].context['fileSize'], equals(1024));
      });

      test('should enrich database errors with operation info', () {
        errorReporting.databaseError('Database query failed',
            operation: 'SELECT', context: {'table': 'users'});

        final errors = errorReporting.getRecentErrors();
        expect(errors[0].category, equals(ErrorCategory.database));
        expect(errors[0].context['operation'], equals('SELECT'));
        expect(errors[0].context['table'], equals('users'));
      });

      test('should enrich network errors with request details', () {
        errorReporting.networkError('API request failed',
            endpoint: '/api/v1/tracks',
            statusCode: 404,
            context: {'method': 'GET'});

        final errors = errorReporting.getRecentErrors();
        expect(errors[0].category, equals(ErrorCategory.network));
        expect(errors[0].context['endpoint'], equals('/api/v1/tracks'));
        expect(errors[0].context['statusCode'], equals(404));
        expect(errors[0].context['method'], equals('GET'));
      });

      test(
          'should handle input validation errors without logging sensitive data',
          () {
        errorReporting.inputValidationError('Invalid email format',
            fieldName: 'email', inputValue: 'user@invalid');

        final errors = errorReporting.getRecentErrors();
        expect(errors[0].category, equals(ErrorCategory.userInput));
        expect(errors[0].context['fieldName'], equals('email'));
        expect(errors[0].context['hasInputValue'], isTrue);
        expect(errors[0].context.containsKey('inputValue'), isFalse);
      });
    });

    group('Error History Management', () {
      test('should limit error history size', () {
        // Add more than maxErrorHistory errors
        for (int i = 0; i < ErrorReportingService.maxErrorHistory + 10; i++) {
          errorReporting.info('Error $i');
        }

        final errors = errorReporting.getRecentErrors();
        expect(errors.length, equals(ErrorReportingService.maxErrorHistory));
        // Should keep the most recent errors
        expect(errors.last.message,
            equals('Error ${ErrorReportingService.maxErrorHistory + 9}'));
      });

      test('should filter errors by minimum level', () {
        errorReporting.debug('Debug message');
        errorReporting.info('Info message');
        errorReporting.warning('Warning message');
        errorReporting.error('Error message');

        final warningAndAbove =
            errorReporting.getRecentErrors(minLevel: LogLevel.warning);
        expect(warningAndAbove.length, equals(2));
        expect(warningAndAbove[0].level, equals(LogLevel.warning));
        expect(warningAndAbove[1].level, equals(LogLevel.error));
      });

      test('should limit returned errors', () {
        for (int i = 0; i < 10; i++) {
          errorReporting.info('Error $i');
        }

        final limitedErrors = errorReporting.getRecentErrors(limit: 5);
        expect(limitedErrors.length, equals(5));
        // Should return the most recent errors
        expect(limitedErrors.last.message, equals('Error 9'));
      });

      test('should clear error history', () {
        errorReporting.error('Test error');
        expect(errorReporting.getRecentErrors().length, equals(1));

        errorReporting.clearHistory();
        expect(errorReporting.getRecentErrors().length, equals(0));
      });
    });

    group('Error Statistics', () {
      test('should calculate error statistics correctly', () {
        errorReporting.debug('Debug 1');
        errorReporting.debug('Debug 2');
        errorReporting.info('Info 1');
        errorReporting.warning('Warning 1');
        errorReporting.error('Error 1', category: ErrorCategory.database);
        errorReporting.error('Error 2', category: ErrorCategory.network);

        final stats = errorReporting.getErrorStats();
        expect(stats['totalErrors'], equals(6));
        expect(stats['byLevel']['debug'], equals(2));
        expect(stats['byLevel']['info'], equals(1));
        expect(stats['byLevel']['warning'], equals(1));
        expect(stats['byLevel']['error'], equals(2));
        expect(stats['byCategory']['database'], equals(1));
        expect(stats['byCategory']['network'], equals(1));
        expect(stats['byCategory']['system'],
            equals(3)); // debug(2) + info(1) default to system
        expect(stats['byCategory']['unknown'],
            equals(1)); // warning defaults to unknown
      });
    });

    group('ErrorReport', () {
      test('should create error report with timestamp', () {
        final report = ErrorReport(
          message: 'Test error',
          level: LogLevel.error,
          category: ErrorCategory.system,
        );

        expect(report.message, equals('Test error'));
        expect(report.level, equals(LogLevel.error));
        expect(report.category, equals(ErrorCategory.system));
        expect(report.timestamp, isA<DateTime>());
        expect(report.context, isEmpty);
      });

      test('should serialize to JSON', () {
        final report = ErrorReport(
          message: 'Test error',
          error: Exception('Test exception'),
          level: LogLevel.error,
          category: ErrorCategory.database,
          context: {'operation': 'SELECT'},
        );

        final json = report.toJson();
        expect(json['message'], equals('Test error'));
        expect(json['error'], contains('Test exception'));
        expect(json['level'], equals('error'));
        expect(json['category'], equals('database'));
        expect(json['timestamp'], isA<String>());
        expect(json['context']['operation'], equals('SELECT'));
      });
    });

    group('Configuration', () {
      test('should enable/disable error collection', () {
        expect(errorReporting.errorCollectionEnabled, isFalse);

        errorReporting.setErrorCollectionEnabled(true);
        expect(errorReporting.errorCollectionEnabled, isTrue);

        errorReporting.setErrorCollectionEnabled(false);
        expect(errorReporting.errorCollectionEnabled, isFalse);
      });
    });
  });
}
