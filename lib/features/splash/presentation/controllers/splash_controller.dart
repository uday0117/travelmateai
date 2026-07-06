import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:travelmateai/app/bootstrap.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/remote_config_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/splash/presentation/pages/maintenance_page.dart';

class SplashController extends GetxController {
  SplashController(this._storageService);

  final StorageService _storageService;

  @override
  void onReady() {
    super.onReady();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    try {
      await Future.wait([
        Future<void>.delayed(AppConstants.splashDuration),
        Bootstrap.waitForServices(),
      ]);

      if (Get.isRegistered<AnalyticsService>()) {
        await Get.find<AnalyticsService>().logAppOpen();
      }

      final blocked = await _checkRemoteConfigGates();
      if (Get.isRegistered<AdMobService>()) {
        Get.find<AdMobService>().markSplashComplete();
      }
      if (blocked) return;

      if (!Get.isRegistered<AuthController>()) {
        Get.offAllNamed(AppRoutes.onboarding);
        return;
      }

      final auth = Get.find<AuthController>();
      if (auth.isAuthenticated) {
        Get.offAllNamed(AppRoutes.home);
        return;
      }

      if (_storageService.hasCompletedOnboarding) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    } catch (e, st) {
      AppLogger.error('Splash navigation failed', e, st);
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  Future<bool> _checkRemoteConfigGates() async {
    if (!Get.isRegistered<RemoteConfigService>()) return false;

    final config = Get.find<RemoteConfigService>();
    if (config.maintenanceMode) {
      Get.offAll(() => const MaintenancePage());
      return true;
    }

    final info = await PackageInfo.fromPlatform();
    if (RemoteConfigService.isUpdateRequired(
      currentVersion: info.version,
      minAppVersion: config.minAppVersion,
    )) {
      Get.offAll(() => const MaintenancePage(forceUpdate: true));
      return true;
    }

    return false;
  }
}
