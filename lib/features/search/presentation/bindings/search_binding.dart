import 'package:get/get.dart';
import 'package:travelmateai/core/services/search_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/features/auth/presentation/bindings/auth_binding.dart';
import 'package:travelmateai/features/search/presentation/controllers/search_controller.dart';
import 'package:travelmateai/features/trips/presentation/bindings/trips_binding.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    TripsBinding().dependencies();
    SyncServiceBinding.registerDocuments();
    SyncServiceBinding.registerJournal();

    if (!Get.isRegistered<SearchService>()) {
      Get.lazyPut(() => SearchService(Get.find()));
    }

    Get.lazyPut(
      () => AppSearchController(
        searchService: Get.find(),
        tripRepository: Get.find(),
        journalRepository: Get.find(),
        documentRepository: Get.find(),
      ),
    );
  }
}
