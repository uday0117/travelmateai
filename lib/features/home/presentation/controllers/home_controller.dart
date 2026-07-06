import 'package:get/get.dart';
import 'package:travelmateai/core/constants/home_constants.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/currency_service.dart';
import 'package:travelmateai/core/services/recent_destinations_service.dart';
import 'package:travelmateai/core/services/weather_service.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/explore/data/repositories/travel_stats_repository.dart';
import 'package:travelmateai/features/explore/data/repositories/visited_place_repository.dart';
import 'package:travelmateai/features/explore/domain/entities/travel_stats.dart';
import 'package:travelmateai/features/explore/domain/entities/visited_place.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

/// Home tab state — dashboard data, tab index, and refresh.
class HomeController extends GetxController {
  HomeController({
    required RecentDestinationsService recentDestinations,
    required WeatherService weatherService,
    required CurrencyService currencyService,
    required TravelStatsRepository travelStatsRepository,
    required VisitedPlaceRepository visitedPlaceRepository,
  })  : _recentDestinations = recentDestinations,
        _weatherService = weatherService,
        _currencyService = currencyService,
        _travelStatsRepository = travelStatsRepository,
        _visitedPlaceRepository = visitedPlaceRepository;

  final RecentDestinationsService _recentDestinations;
  final WeatherService _weatherService;
  final CurrencyService _currencyService;
  final TravelStatsRepository _travelStatsRepository;
  final VisitedPlaceRepository _visitedPlaceRepository;

  final RxInt currentIndex = 0.obs;
  final RxBool isRefreshing = false.obs;
  final Rxn<WeatherData> weather = Rxn<WeatherData>();
  final RxMap<String, double> currencyRates = <String, double>{}.obs;
  final Rxn<TravelStats> travelStats = Rxn<TravelStats>();
  final RxList<VisitedPlace> visitedPlaces = <VisitedPlace>[].obs;
  final RxList<String> recentDestinations = <String>[].obs;

  List<DestinationSuggestion> get aiSuggestions => HomeConstants.aiSuggestions;
  List<TravelTip> get travelTips => HomeConstants.travelTips;

  String? get _userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  void changeTab(int index) => currentIndex.value = index;

  Future<void> loadDashboard() async {
    recentDestinations.assignAll(_recentDestinations.getRecent());
    await _loadWeatherAndCurrency();
    await _loadStatsAndPlaces();
  }

  @override
  Future<void> refresh() async {
    isRefreshing.value = true;
    try {
      if (Get.isRegistered<TripsController>()) {
        await Get.find<TripsController>().refresh();
      }
      await loadDashboard();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> recordDestinationView(String destination) async {
    await _recentDestinations.record(destination);
    recentDestinations.assignAll(_recentDestinations.getRecent());
  }

  Future<void> _loadWeatherAndCurrency() async {
    final trips = Get.isRegistered<TripsController>() ? Get.find<TripsController>() : null;
    final city = trips?.activeTrips.firstOrNull?.destination ??
        trips?.upcomingTrips.firstOrNull?.destination ??
        'London';
    final cityName = city.split(',').first.trim();

    final results = await Future.wait([
      _weatherService.getWeather(cityName),
      _currencyService.getRates(),
    ]);

    weather.value = results[0] as WeatherData?;
    currencyRates.assignAll(results[1] as Map<String, double>);

    if (Get.isRegistered<AnalyticsService>() && weather.value != null) {
      await Get.find<AnalyticsService>().logWeatherViewed(city: weather.value!.city);
    }
  }

  Future<void> _loadStatsAndPlaces() async {
    final userId = _userId;
    if (userId == null) return;

    if (Get.isRegistered<TripsController>()) {
      final trips = Get.find<TripsController>().trips;
      travelStats.value = await _travelStatsRepository.computeForUser(userId, trips);
      await _visitedPlaceRepository.recordFromCompletedTrips(userId, trips);
    }

    visitedPlaces.assignAll(await _visitedPlaceRepository.getAll(userId));
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
