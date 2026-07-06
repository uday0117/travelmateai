import 'package:firebase_core/firebase_core.dart';
import 'package:travelmateai/config/firebase_options.dart';
import 'package:travelmateai/core/logging/app_logger.dart';

/// Initializes Firebase and related SDKs.
class FirebaseService {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      AppLogger.info('Firebase initialized');
    } catch (e, st) {
      AppLogger.warning(
        'Firebase init failed — running in offline/demo mode. '
        'Run `flutterfire configure` to connect Firebase.',
        e,
        st,
      );
    }
  }
}
