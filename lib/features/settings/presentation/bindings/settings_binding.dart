import 'package:get/get.dart';
import 'package:travelmateai/core/services/notification_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/core/theme/theme_controller.dart';
import 'package:travelmateai/features/auth/presentation/bindings/auth_binding.dart';
import 'package:travelmateai/features/settings/presentation/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    Get.lazyPut(
      () => SettingsController(
        themeController: Get.find<ThemeController>(),
        storageService: Get.find<StorageService>(),
        syncService: Get.find<SyncService>(),
        notificationService: Get.find<NotificationService>(),
      ),
    );
  }
}
