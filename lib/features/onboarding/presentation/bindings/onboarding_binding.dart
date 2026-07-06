import 'package:get/get.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/features/onboarding/presentation/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController(Get.find<StorageService>()));
  }
}
