import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/services/storage_service.dart';

/// Global theme mode state for GetMaterialApp.
class ThemeController extends GetxController {
  ThemeController(this._storageService);

  final StorageService _storageService;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _storageService.themeMode;
    themeMode.value = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _storageService.setThemeMode(switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }
}
