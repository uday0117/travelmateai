import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/firebase_service.dart';

/// Firebase App Check — protects Firestore, Storage, and Auth backends.
class AppCheckService extends GetxService {
  final RxBool isActivated = false.obs;

  Future<AppCheckService> init() async {
    if (!FirebaseService.isInitialized) return this;
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.appAttest,
      );
      isActivated.value = true;
      AppLogger.info('Firebase App Check activated');
    } catch (e, st) {
      AppLogger.warning('App Check activation failed', e, st);
    }
    return this;
  }
}
