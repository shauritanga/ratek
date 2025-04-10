import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  bool _isEnabled = true;
  LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  void enable() => _isEnabled = true;
  void disable() => _isEnabled = false;
  void setMinLevel(LogLevel level) => _minLevel = level;

  void _log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    if (!_isEnabled || level.index < _minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.toString().split('.').last.toUpperCase();
    final logMessage = '[$timestamp] $levelStr: $message';

    if (error != null) {
      developer.log(
        logMessage,
        error: error,
        stackTrace: stackTrace,
        level: level.index,
      );
    } else {
      developer.log(
        logMessage,
        level: level.index,
      );
    }

    // In debug mode, also print to console
    if (kDebugMode) {
      print(logMessage);
      if (error != null) {
        print('Error: $error');
        print('StackTrace: $stackTrace');
      }
    }
  }

  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.info, message, error, stackTrace);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.warning, message, error, stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  // Log HTTP request
  void logRequest(String method, String url, {Map<String, dynamic>? headers, dynamic body}) {
    if (!_isEnabled || LogLevel.debug.index < _minLevel.index) return;

    final logMessage = '''
HTTP Request:
  Method: $method
  URL: $url
  Headers: $headers
  Body: $body
''';
    debug(logMessage);
  }

  // Log HTTP response
  void logResponse(String method, String url, int statusCode, dynamic body) {
    if (!_isEnabled || LogLevel.debug.index < _minLevel.index) return;

    final logMessage = '''
HTTP Response:
  Method: $method
  URL: $url
  Status Code: $statusCode
  Body: $body
''';
    debug(logMessage);
  }

  // Log database operation
  void logDatabaseOperation(String operation, String table, {Map<String, dynamic>? data}) {
    if (!_isEnabled || LogLevel.debug.index < _minLevel.index) return;

    final logMessage = '''
Database Operation:
  Operation: $operation
  Table: $table
  Data: $data
''';
    debug(logMessage);
  }

  // Log user action
  void logUserAction(String action, {Map<String, dynamic>? details}) {
    if (!_isEnabled || LogLevel.info.index < _minLevel.index) return;

    final logMessage = '''
User Action:
  Action: $action
  Details: $details
''';
    info(logMessage);
  }

  // Log error with context
  void logError(String context, Object error, StackTrace stackTrace) {
    final logMessage = '''
Error in $context:
  Error: $error
  StackTrace: $stackTrace
''';
    this.error(logMessage);
  }
} 