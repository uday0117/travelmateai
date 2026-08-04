import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelmateai/core/services/recent_destinations_service.dart';
import 'package:travelmateai/core/services/sync_service.dart';
import 'package:travelmateai/features/auth/presentation/bindings/auth_binding.dart';
import 'package:travelmateai/features/expenses/presentation/bindings/expenses_binding.dart';
import 'package:travelmateai/features/home/presentation/controllers/home_controller.dart';
import 'package:travelmateai/features/journal/presentation/controllers/journal_controller.dart';
import 'package:travelmateai/features/packing/presentation/controllers/packing_controller.dart';
import 'package:travelmateai/features/trips/presentation/bindings/trips_binding.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    AuthBinding().dependencies();
    TripsBinding().dependencies();
    ExpensesBinding().dependencies();
    JournalBinding().dependencies();
    PackingBinding().dependencies();
    SyncServiceBinding.registerFavorites();
    SyncServiceBinding.registerExplore();

    if (!Get.isRegistered<RecentDestinationsService>()) {
      Get.lazyPut(() => RecentDestinationsService(Get.find<GetStorage>()));
    }

    Get.lazyPut<HomeController>(
      () => HomeController(
        recentDestinations: Get.find(),
        weatherService: Get.find(),
        currencyService: Get.find(),
        travelStatsRepository: Get.find(),
        visitedPlaceRepository: Get.find(),
      ),
    );
  }
}
