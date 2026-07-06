import 'package:get/get.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/features/ai/models/ai_feature_type.dart';
import 'package:travelmateai/features/expenses/presentation/controllers/expenses_controller.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class AiHubController extends GetxController {
  AiHubController(this._aiService);

  final AiService _aiService;

  final RxBool isGenerating = false.obs;
  final RxnString resultTitle = RxnString();
  final RxnString resultContent = RxnString();

  bool get isAiEnabled => _aiService.isAvailable;

  Trip? get _selectedTrip {
    if (!Get.isRegistered<TripsController>()) return null;
    final trips = Get.find<TripsController>();
    return trips.activeTrips.firstOrNull ??
        trips.upcomingTrips.firstOrNull ??
        trips.trips.firstOrNull;
  }

  Future<void> runFeature(AiFeatureType feature) async {
    if (feature == AiFeatureType.chat) return;

    final trip = _selectedTrip;
    isGenerating.value = true;
    resultTitle.value = feature.title;
    resultContent.value = null;

    try {
      final content = switch (feature) {
        AiFeatureType.tripPlanner => await _runTripPlanner(trip),
        AiFeatureType.packing => await _runPacking(trip),
        AiFeatureType.budget => await _runBudget(trip),
        AiFeatureType.destinations => await _runDestinations(),
        AiFeatureType.itinerary => await _runItinerary(trip),
        AiFeatureType.travelTips => await _runTravelTips(trip),
        AiFeatureType.chat => '',
      };
      resultContent.value = content;
    } catch (e) {
      Get.context?.showAppSnackBar(
        ErrorMapper.userMessage(ErrorMapper.mapException(e)),
        isError: true,
      );
    } finally {
      isGenerating.value = false;
    }
  }

  Future<String> _runTripPlanner(Trip? trip) async {
    if (trip == null) {
      throw const ValidationException('Create a trip first to use the AI Trip Planner');
    }
    return _aiService.planTrip(
      destination: trip.destination,
      durationDays: trip.durationDays,
      travelers: trip.travelers,
      budget: '${trip.currency} ${trip.budget.toStringAsFixed(0)}',
      notes: trip.notes,
    );
  }

  Future<String> _runPacking(Trip? trip) async {
    if (trip == null) {
      throw const ValidationException('Create a trip first for packing suggestions');
    }
    final items = await _aiService.suggestPacking(
      destination: trip.destination,
      durationDays: trip.durationDays,
    );
    return 'Suggested packing items for ${trip.destination}:\n\n'
        '${items.map((i) => '• $i').join('\n')}';
  }

  Future<String> _runBudget(Trip? trip) async {
    if (trip == null) {
      throw const ValidationException('Create a trip first for budget analysis');
    }
    var spent = 0.0;
    var count = 0;
    if (Get.isRegistered<ExpensesController>()) {
      final expenses = Get.find<ExpensesController>();
      spent = expenses.total;
      count = expenses.expenses.length;
    }
    return _aiService.suggestBudget(
      trip: trip,
      spentSoFar: spent,
      expenseCount: count,
    );
  }

  Future<String> _runDestinations() async {
    String? recent;
    if (Get.isRegistered<TripsController>()) {
      final trips = Get.find<TripsController>().trips;
      if (trips.isNotEmpty) {
        recent = trips.map((t) => t.destination).take(5).join(', ');
      }
    }
    return _aiService.recommendDestinations(recentDestinations: recent);
  }

  Future<String> _runItinerary(Trip? trip) async {
    if (trip == null) {
      throw const ValidationException('Create a trip first for a daily itinerary');
    }
    return _aiService.generateDailyItinerary(trip: trip);
  }

  Future<String> _runTravelTips(Trip? trip) async {
    final destination = trip?.destination ?? 'international travel';
    return _aiService.generateTravelTips(
      destination: destination,
      daysUntilTrip: trip?.daysUntilStart,
    );
  }

  void clearResult() {
    resultTitle.value = null;
    resultContent.value = null;
  }
}
