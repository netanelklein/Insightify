/// Error reporting and structured logging utility
///
/// Provides comprehensive error handling, crash reporting, and logging
/// capabilities for production builds with privacy considerations.
library;

import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Severity levels for logging
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// Error categories for better organization
enum ErrorCategory {
  userInput,
  fileProcessing,
  database,
  network,
  ui,
  system,
  unknown,
}

/// Structured error report
class ErrorReport {
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final LogLevel level;
  final ErrorCategory category;
  final DateTime timestamp;
  final Map<String, dynamic> context;

  ErrorReport({
    required this.message,
    this.error,
    this.stackTrace,
    required this.level,
    required this.category,
    Map<String, dynamic>? context,
  })  : timestamp = DateTime.now(),
        context = context ?? {};

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'level': level.name,
      'category': category.name,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
    };
  }
}

/// Main error reporting and logging service
class ErrorReportingService {
  static final ErrorReportingService _instance =
      ErrorReportingService._internal();
  factory ErrorReportingService() => _instance;
  ErrorReportingService._internal();

  final List<ErrorReport> _errorHistory = [];
  static const int maxErrorHistory = 100;

  /// Whether to enable debug logging in development
  bool debugLoggingEnabled = true;

  /// Whether to collect error reports for analytics (with user consent)
  bool errorCollectionEnabled = false;

  /// Log a debug message (development only)
  void debug(String message, {Map<String, dynamic>? context}) {
    _log(LogLevel.debug, ErrorCategory.system, message, context: context);
  }

  /// Log an informational message
  void info(String message, {Map<String, dynamic>? context}) {
    _log(LogLevel.info, ErrorCategory.system, message, context: context);
  }

  /// Log a warning
  void warning(String message,
      {ErrorCategory? category, Map<String, dynamic>? context}) {
    _log(LogLevel.warning, category ?? ErrorCategory.unknown, message,
        context: context);
  }

  /// Log an error
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    ErrorCategory? category,
    Map<String, dynamic>? context,
  }) {
    _log(LogLevel.error, category ?? ErrorCategory.unknown, message,
        error: error, stackTrace: stackTrace, context: context);
  }

  /// Log a critical error that may require immediate attention
  void critical(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    ErrorCategory? category,
    Map<String, dynamic>? context,
  }) {
    _log(LogLevel.critical, category ?? ErrorCategory.unknown, message,
        error: error, stackTrace: stackTrace, context: context);
  }

  /// Log file processing errors
  void fileError(
    String message,
    String? fileName, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final enrichedContext = {
      'fileName': fileName,
      ...?context,
    };

    _log(LogLevel.error, ErrorCategory.fileProcessing, message,
        error: error, stackTrace: stackTrace, context: enrichedContext);
  }

  /// Log database errors
  void databaseError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? operation,
    Map<String, dynamic>? context,
  }) {
    final enrichedContext = {
      'operation': operation,
      ...?context,
    };

    _log(LogLevel.error, ErrorCategory.database, message,
        error: error, stackTrace: stackTrace, context: enrichedContext);
  }

  /// Log network/API errors
  void networkError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? endpoint,
    int? statusCode,
    Map<String, dynamic>? context,
  }) {
    final enrichedContext = {
      'endpoint': endpoint,
      'statusCode': statusCode,
      ...?context,
    };

    _log(LogLevel.error, ErrorCategory.network, message,
        error: error, stackTrace: stackTrace, context: enrichedContext);
  }

  /// Log user input validation errors
  void inputValidationError(
    String message, {
    String? fieldName,
    String? inputValue,
    Map<String, dynamic>? context,
  }) {
    final enrichedContext = {
      'fieldName': fieldName,
      // Don't log actual input values for privacy
      'hasInputValue': inputValue != null,
      ...?context,
    };

    _log(LogLevel.warning, ErrorCategory.userInput, message,
        context: enrichedContext);
  }

  /// Internal logging method
  void _log(
    LogLevel level,
    ErrorCategory category,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    final report = ErrorReport(
      message: message,
      error: error,
      stackTrace: stackTrace,
      level: level,
      category: category,
      context: context,
    );

    // Add to error history
    _errorHistory.add(report);
    if (_errorHistory.length > maxErrorHistory) {
      _errorHistory.removeAt(0);
    }

    // Log to console in development
    if (debugLoggingEnabled) {
      _logToConsole(report);
    }

    // For critical errors, consider immediate reporting
    if (level == LogLevel.critical && errorCollectionEnabled) {
      _reportCriticalError(report);
    }
  }

  /// Log to console with proper formatting
  void _logToConsole(ErrorReport report) {
    final prefix =
        '[${report.level.name.toUpperCase()}] [${report.category.name}]';

    developer.log(
      '$prefix ${report.message}',
      time: report.timestamp,
      level: _getLogLevelValue(report.level),
      name: 'SpotifyAnalyzer',
      error: report.error,
      stackTrace: report.stackTrace,
    );

    // Additional context logging
    if (report.context.isNotEmpty) {
      developer.log(
        'Context: ${report.context}',
        time: report.timestamp,
        level: _getLogLevelValue(LogLevel.debug),
        name: 'SpotifyAnalyzer',
      );
    }
  }

  /// Convert LogLevel to dart:developer log level values
  int _getLogLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 300;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }

  /// Report critical errors (could be extended to use crash reporting services)
  Future<void> _reportCriticalError(ErrorReport report) async {
    // In a production app, this would send to a crash reporting service
    // For now, we'll just log it prominently
    developer.log(
      'CRITICAL ERROR: ${report.message}',
      time: report.timestamp,
      level: 1200,
      name: 'SpotifyAnalyzer-Critical',
      error: report.error,
      stackTrace: report.stackTrace,
    );
  }

  /// Get recent error history for debugging
  List<ErrorReport> getRecentErrors({int? limit, LogLevel? minLevel}) {
    var filtered = _errorHistory.where((report) {
      if (minLevel != null) {
        return _getLogLevelValue(report.level) >= _getLogLevelValue(minLevel);
      }
      return true;
    }).toList();

    if (limit != null && filtered.length > limit) {
      filtered = filtered.sublist(filtered.length - limit);
    }

    return filtered;
  }

  /// Get error statistics
  Map<String, dynamic> getErrorStats() {
    final stats = <String, dynamic>{
      'totalErrors': _errorHistory.length,
      'byLevel': <String, int>{},
      'byCategory': <String, int>{},
    };

    for (final report in _errorHistory) {
      final levelKey = report.level.name;
      final categoryKey = report.category.name;

      stats['byLevel'][levelKey] = (stats['byLevel'][levelKey] ?? 0) + 1;
      stats['byCategory'][categoryKey] =
          (stats['byCategory'][categoryKey] ?? 0) + 1;
    }

    return stats;
  }

  /// Clear error history (useful for testing)
  void clearHistory() {
    _errorHistory.clear();
  }

  /// Set up global error handling
  void setupGlobalErrorHandling() {
    // Catch uncaught Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      critical(
        'Uncaught Flutter error: ${details.summary}',
        error: details.exception,
        stackTrace: details.stack,
        category: ErrorCategory.ui,
        context: {
          'library': details.library,
          'informationCollector': details.informationCollector?.toString(),
        },
      );
    };

    // Catch uncaught async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      critical(
        'Uncaught async error',
        error: error,
        stackTrace: stack,
        category: ErrorCategory.system,
      );
      return true;
    };
  }

  /// Enable or disable error collection (with user consent)
  void setErrorCollectionEnabled(bool enabled) {
    errorCollectionEnabled = enabled;
    info('Error collection ${enabled ? 'enabled' : 'disabled'}');
  }
}
