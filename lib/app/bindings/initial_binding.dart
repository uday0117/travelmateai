import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/core/network/api_client.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/core/services/ai/ai_provider.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/core/services/ai/gemini_ai_provider.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/crash_reporting_service.dart';
import 'package:travelmateai/core/services/currency_service.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/encryption_service.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:travelmateai/core/services/notification_service.dart';
import 'package:travelmateai/core/services/app_check_service.dart';
import 'package:travelmateai/core/services/remote_config_service.dart';
import 'package:travelmateai/core/services/search_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/core/services/weather_service.dart';
import 'package:travelmateai/core/theme/theme_controller.dart';

/// Global dependency injection for core services.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    Get.put<StorageService>(StorageService(Get.find()), permanent: true);
    Get.put<ThemeController>(ThemeController(Get.find()), permanent: true);

    Get.lazyPut<Connectivity>(() => Connectivity(), fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()), fenix: true);
    Get.lazyPut<ApiClient>(ApiClient.new, fenix: true);
    if (!Get.isRegistered<DatabaseService>()) {
      Get.lazyPut<DatabaseService>(DatabaseService.new, fenix: true);
    }
    if (!Get.isRegistered<SearchService>()) {
      Get.lazyPut(() => SearchService(Get.find()));
    }
    Get.lazyPut<SyncService>(
      () => SyncService(Get.find<NetworkInfo>(), Get.find<StorageService>()),
      fenix: true,
    );
    Get.lazyPut<AiProvider>(GeminiAiProvider.new, fenix: true);
    Get.lazyPut<AiService>(() => AiService(Get.find()), fenix: true);
    Get.lazyPut<EncryptionService>(EncryptionService.new, fenix: true);
    Get.lazyPut<WeatherService>(() => WeatherService(Get.find()), fenix: true);
    Get.lazyPut<CurrencyService>(() => CurrencyService(Get.find(), Get.find()), fenix: true);
    Get.put<AppCheckService>(AppCheckService(), permanent: true);
    Get.put<AdMobService>(AdMobService(), permanent: true);
    Get.lazyPut<NotificationService>(NotificationService.new, fenix: true);

    if (FirebaseService.isInitialized) {
      Get.lazyPut<FirebaseAnalytics>(() => FirebaseAnalytics.instance, fenix: true);
      Get.lazyPut<AnalyticsService>(() => AnalyticsService(Get.find()), fenix: true);
      Get.lazyPut<FirebaseCrashlytics>(() => FirebaseCrashlytics.instance, fenix: true);
      Get.lazyPut<CrashReportingService>(() => CrashReportingService(Get.find()), fenix: true);
      Get.lazyPut<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance, fenix: true);
      Get.lazyPut<RemoteConfigService>(() => RemoteConfigService(Get.find()), fenix: true);
    }
  }
}
