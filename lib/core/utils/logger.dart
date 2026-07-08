import 'package:flutter/foundation.dart';

/// Structured logging levels for JanSetu AI Enterprise Portal.
enum LogLevel { info, warning, error, success }

/// Centralized Logger (JanSetuLogger)
/// Prints formatted diagnostic output during debug development.
/// Strictly disabled in Release builds per Prompt 14 security requirements.
class JanSetuLogger {
  static void info(String message, [String? tag]) {
    _log(LogLevel.info, message, tag);
  }

  static void warning(String message, [String? tag]) {
    _log(LogLevel.warning, message, tag);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace, String? tag]) {
    _log(LogLevel.error, '$message${error != null ? ' | Error: $error' : ''}', tag);
    if (kDebugMode && stackTrace != null) {
      debugPrint('📚 [JanSetu-StackTrace]: $stackTrace');
    }
  }

  static void success(String message, [String? tag]) {
    _log(LogLevel.success, message, tag);
  }

  static void _log(LogLevel level, String message, String? tag) {
    if (!kDebugMode) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final prefix = tag != null ? '[$tag]' : '[JanSetu-Core]';
    String icon;

    switch (level) {
      case LogLevel.info:
        icon = 'ℹ️';
        break;
      case LogLevel.warning:
        icon = '⚠️';
        break;
      case LogLevel.error:
        icon = '❌';
        break;
      case LogLevel.success:
        icon = '✅';
        break;
    }

    debugPrint('$icon $timestamp $prefix $message');
  }
}
