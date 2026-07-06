import 'package:get/get.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/features/auth/presentation/bindings/auth_binding.dart';
import 'package:travelmateai/features/splash/presentation/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    Get.put(SplashController(Get.find<StorageService>()));
  }
}
