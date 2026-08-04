import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/core/theme/theme_controller.dart';

class _FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => './test_storage';
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = _FakePathProvider();
    AppLogger.init();
    await GetStorage.init('test');
  });

  tearDown(Get.reset);

  test('AppConstants defines production metadata', () {
    expect(AppConstants.appName, 'TravelMate AI');
    expect(AppConstants.packageName, 'com.uksolutions.travelmateai');
  });

  test('ThemeController persists theme mode', () async {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    final storage = StorageService(Get.find());
    final controller = ThemeController(storage);

    await controller.setThemeMode(ThemeMode.dark);
    expect(controller.themeMode.value, ThemeMode.dark);
    expect(storage.themeMode, 'dark');
  });

  test('StorageService persists onboarding and profile avatar values', () async {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    final storage = StorageService(Get.find());

    await storage.setOnboardingComplete(true);
    await storage.setProfileAvatarPath('/tmp/avatar.png');

    expect(storage.hasCompletedOnboarding, isTrue);
    expect(storage.profileAvatarPath, '/tmp/avatar.png');
  });
}
