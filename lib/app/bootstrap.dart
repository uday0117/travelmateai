import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/config/env_config.dart';
import 'package:travelmateai/core/database/app_isar_schemas.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/firebase_service.dart';

abstract final class Bootstrap {
  static final Completer<void> _servicesReady = Completer<void>();

  /// Completes once non-critical startup services have finished initializing.
  static Future<void> waitForServices() => _servicesReady.future;

  static void markServicesReady() {
    if (!_servicesReady.isCompleted) {
      _servicesReady.complete();
    }
  }
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.init();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await _loadEnvironment();
    await GetStorage.init();
    await FirebaseService.init();
    await _initDatabase();

    if (FirebaseService.isInitialized) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    await _initFirebaseServices();
  }

  static Future<void> _loadEnvironment() async {
    const keys = (
      gemini: 'GEMINI_API_KEY',
      openWeather: 'OPENWEATHER_API_KEY',
      exchangeRate: 'EXCHANGE_RATE_API_KEY',
      googleMaps: 'GOOGLE_MAPS_API_KEY',
    );

    for (final fileName in ['.env', '.env.example']) {
      try {
        await dotenv.load(fileName: fileName);
        break;
      } catch (_) {
        if (fileName == '.env.example') {
          AppLogger.warning(
            'No .env asset found. Add .env to the project root for API keys.',
          );
        }
      }
    }

    EnvConfig.load(
      gemini: dotenv.env[keys.gemini]?.trim() ?? '',
      openWeather: dotenv.env[keys.openWeather]?.trim() ?? '',
      exchangeRate: dotenv.env[keys.exchangeRate]?.trim() ?? '',
      googleMaps: dotenv.env[keys.googleMaps]?.trim() ?? '',
    );

    if (EnvConfig.geminiApiKey.isEmpty) {
      AppLogger.warning(
        'GEMINI_API_KEY is empty — AI features disabled until you add a key to .env',
      );
    }
  }

  static Future<void> _initDatabase() async {
    try {
      final db = DatabaseService();
      await db.init(AppIsarSchemas.all);
      Get.put<DatabaseService>(db, permanent: true);
    } catch (e, st) {
      AppLogger.error('Database init failed', e, st);
    }
  }

  static Future<void> _initFirebaseServices() async {
    if (!FirebaseService.isInitialized) return;
    try {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await FirebaseRemoteConfig.instance.setDefaults(const {
        'enable_ads': true,
        'enable_ai_features': true,
      });
    } catch (e, st) {
      AppLogger.warning('Firebase services init partial failure', e, st);
    }
  }
}
