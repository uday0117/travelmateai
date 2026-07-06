import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized application logging.
abstract final class AppLogger {
  static Logger? _logger;

  static Logger get _instance {
    _logger ??= Logger(
      level: kReleaseMode ? Level.warning : Level.debug,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: !kReleaseMode,
        printEmojis: !kReleaseMode,
      ),
    );
    return _logger!;
  }

  static void init({Level level = Level.debug}) {
    _logger = Logger(
      level: kReleaseMode ? Level.warning : level,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: !kReleaseMode,
        printEmojis: !kReleaseMode,
      ),
    );
  }

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _instance.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _instance.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _instance.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _instance.e(message, error: error, stackTrace: stackTrace);
  }
}
