import 'package:get/get.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';

/// Controller for trip detail view.
class TripDetailController extends GetxController {
  TripDetailController(this._tripRepository);

  final TripRepository _tripRepository;

  final Rxn<Trip> trip = Rxn<Trip>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Trip) {
      trip.value = args;
      isLoading.value = false;
    } else if (args is String) {
      _loadTrip(args);
    }
  }

  Future<void> _loadTrip(String id) async {
    isLoading.value = true;
    try {
      trip.value = await _tripRepository.getById(id);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    final id = trip.value?.id;
    if (id == null) return;
    await _loadTrip(id);
  }
}
