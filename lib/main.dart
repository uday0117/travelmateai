import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/app/app.dart';
import 'package:travelmateai/app/bindings/initial_binding.dart';
import 'package:travelmateai/app/bootstrap.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/core/services/encryption_service.dart';
import 'package:travelmateai/core/services/notification_service.dart';
import 'package:travelmateai/core/services/app_check_service.dart';
import 'package:travelmateai/core/services/remote_config_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';

Future<void> main() async {
  await Bootstrap.init();
  InitialBinding().dependencies();
  runApp(const TravelMateApp());
  unawaited(_initAppServices());
}

Future<void> _initAppServices() async {
  try {
    await Get.find<EncryptionService>().init();
    await Get.find<AppCheckService>().init();
    if (Get.isRegistered<RemoteConfigService>()) {
      await Get.find<RemoteConfigService>().init();
      if (Get.isRegistered<AdMobService>()) {
        Get.find<AdMobService>().applyRemoteConfig();
      }
    }
    await Get.find<AdMobService>().init();
    if (Get.isRegistered<NotificationService>()) {
      await Get.find<NotificationService>().init();
    }
    if (Get.isRegistered<SyncService>()) {
      Get.find<SyncService>().startAutoSync();
    }
  } finally {
    Bootstrap.markServicesReady();
  }
}
