import 'package:get/get.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/trips/data/datasources/trip_local_datasource.dart';
import 'package:travelmateai/features/trips/data/datasources/trip_remote_datasource.dart';
import 'package:travelmateai/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trip_detail_controller.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trip_form_controller.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class TripsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripLocalDataSource>(
      () => TripLocalDataSource(Get.find<DatabaseService>()),
    );
    Get.lazyPut<TripRemoteDataSource>(TripRemoteDataSource.new);
    Get.lazyPut<TripRepository>(
      () => TripRepositoryImpl(
        localDataSource: Get.find(),
        remoteDataSource: Get.find(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    Get.lazyPut<TripsController>(() => TripsController(Get.find()));
  }
}

class TripFormBinding extends Bindings {
  @override
  void dependencies() {
    TripsBinding().dependencies();
    Get.lazyPut<TripFormController>(() => TripFormController(Get.find()));
  }
}

class TripDetailBinding extends Bindings {
  @override
  void dependencies() {
    TripsBinding().dependencies();
    Get.lazyPut<TripDetailController>(() => TripDetailController(Get.find()));
  }
}
