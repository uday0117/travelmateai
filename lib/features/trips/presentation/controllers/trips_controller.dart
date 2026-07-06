import 'package:get/get.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';

/// Manages trip list state, filters, and actions.
class TripsController extends GetxController {
  TripsController(this._tripRepository);

  final TripRepository _tripRepository;

  final RxList<Trip> trips = <Trip>[].obs;
  final RxList<Trip> upcomingTrips = <Trip>[].obs;
  final RxList<Trip> activeTrips = <Trip>[].obs;
  final RxList<Trip> recentTrips = <Trip>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxBool showArchived = false.obs;
  final RxBool favoritesOnly = false.obs;

  String? get _userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => loadTrips(), time: AppConstants.debounceDuration);
    ever(showArchived, (_) => loadTrips());
    ever(favoritesOnly, (_) => loadTrips());
    loadTrips();
    _watchTrips();
  }

  void _watchTrips() {
    final userId = _userId;
    if (userId == null) return;

    _tripRepository.watchAll(userId: userId).listen((data) {
      trips.assignAll(data.where((t) => !t.isDeleted));
      _updateDashboardLists();
    });
  }

  Future<void> loadTrips() async {
    final userId = _userId;
    if (userId == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    try {
      final filter = TripFilter(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        favoritesOnly: favoritesOnly.value,
        archivedOnly: showArchived.value,
        includeArchived: showArchived.value,
      );
      final result = await _tripRepository.getFiltered(
        userId: userId,
        filter: filter,
      );
      trips.assignAll(result);
      await _updateDashboardLists();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateDashboardLists() async {
    final userId = _userId;
    if (userId == null) return;

    upcomingTrips.assignAll(await _tripRepository.getUpcoming(userId: userId));
    activeTrips.assignAll(await _tripRepository.getActive(userId: userId));
    recentTrips.assignAll(await _tripRepository.getRecent(userId: userId));
  }

  /// Upcoming trips that still need flight, hotel, or budget details.
  List<Trip> get planningTrips => upcomingTrips.where((t) {
        return t.budget <= 0 ||
            (t.flightDetails == null || t.flightDetails!.isEmpty) ||
            (t.hotelDetails == null || t.hotelDetails!.isEmpty);
      }).toList();

  @override
  Future<void> refresh() async {
    await _tripRepository.sync();
    await loadTrips();
  }

  Future<void> deleteTrip(String id) async {
    await _tripRepository.delete(id);
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logTripDeleted(tripId: id);
    }
    Get.context?.showAppSnackBar('Trip deleted');
    await loadTrips();
  }

  Future<void> archiveTrip(String id) async {
    final result = await _tripRepository.archiveTrip(id);
    result.fold(
      (f) => Get.context?.showAppSnackBar(ErrorMapper.userMessage(f), isError: true),
      (_) => Get.context?.showAppSnackBar('Trip archived'),
    );
    await loadTrips();
  }

  Future<void> duplicateTrip(String id) async {
    final result = await _tripRepository.duplicateTrip(id);
    result.fold(
      (f) => Get.context?.showAppSnackBar(ErrorMapper.userMessage(f), isError: true),
      (_) => Get.context?.showAppSnackBar('Trip duplicated'),
    );
    await loadTrips();
  }

  Future<void> toggleFavorite(String id) async {
    await _tripRepository.toggleFavorite(id);
    await loadTrips();
  }

  int get totalTrips => trips.length;
  int get countriesCount => trips.map((t) => t.destination).toSet().length;
}
