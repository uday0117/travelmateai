import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:travelmateai/core/logging/app_logger.dart';

/// Crashlytics error reporting wrapper.
class CrashReportingService {
  CrashReportingService(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  Future<void> init() async {
    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(error, stack, fatal: fatal);
    } catch (e, st) {
      AppLogger.warning('Crashlytics record failed', e, st);
    }
  }

  Future<void> setUserId(String? userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId ?? '');
    } catch (e, st) {
      AppLogger.warning('Crashlytics setUserId failed', e, st);
    }
  }
}
