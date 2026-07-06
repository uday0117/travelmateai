import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/notification_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/core/theme/theme_controller.dart';

class SettingsController extends GetxController {
  SettingsController({
    required ThemeController themeController,
    required StorageService storageService,
    required SyncService syncService,
    required NotificationService notificationService,
  })  : _themeController = themeController,
        _storageService = storageService,
        _syncService = syncService,
        _notificationService = notificationService;

  final ThemeController _themeController;
  final StorageService _storageService;
  final SyncService _syncService;
  final NotificationService _notificationService;

  final RxBool notificationsEnabled = true.obs;
  final RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    notificationsEnabled.value =
        _storageService.read<bool>(AppConstants.notificationsEnabledKey) ?? true;
    ever(_syncService.isSyncing, (v) => isSyncing.value = v);
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _themeController.setThemeMode(mode);

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled.value = enabled;
    await _storageService.write(AppConstants.notificationsEnabledKey, enabled);
    if (enabled) {
      await _notificationService.requestPermission();
    } else {
      await _notificationService.cancelAllLocal();
    }
  }

  String get lastBackupLabel {
    final at = _syncService.lastBackupAt;
    if (at == null) return 'Never synced';
    return DateFormat('MMM d, yyyy · h:mm a').format(at);
  }

  Future<void> backupNow() async {
    final success = await _syncService.syncAll();
    if (success) {
      Get.context?.showAppSnackBar('Backup complete — data synced to cloud');
    }
  }

  Future<void> restoreFromCloud() async {
    final success = await _syncService.syncAll();
    if (success) {
      Get.context?.showAppSnackBar('Restore complete — latest data downloaded');
    }
  }
}
