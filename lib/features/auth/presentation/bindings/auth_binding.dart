import 'package:get/get.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:travelmateai/features/auth/domain/repositories/auth_repository.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        databaseService: Get.isRegistered<DatabaseService>()
            ? Get.find<DatabaseService>()
            : null,
        storageService: Get.isRegistered<StorageService>()
            ? Get.find<StorageService>()
            : null,
      ),
    );
    Get.lazyPut<AuthController>(() => AuthController(Get.find()));
  }
}
