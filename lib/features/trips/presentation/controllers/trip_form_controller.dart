import 'package:get/get.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/notification_service.dart';
import 'package:travelmateai/features/trips/domain/repositories/trip_repository.dart';

/// Controller for creating and editing trips.
class TripFormController extends GetxController {
  TripFormController(this._tripRepository);

  final TripRepository _tripRepository;

  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxString selectedCurrency = 'USD'.obs;
  Trip? _existingTrip;

  String? get userId => Get.find<AuthController>().user.value?.id;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Trip) {
      _existingTrip = args;
      isEditing.value = true;
      selectedCurrency.value = args.currency;
    }
  }

  Trip? get existingTrip => _existingTrip;

  Future<bool> saveTrip({
    required String title,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    double budget = 0,
    String currency = 'USD',
    int travelers = 1,
    String? flightDetails,
    String? hotelDetails,
    String? notes,
  }) async {
    final uid = userId;
    if (uid == null) {
      Get.context?.showAppSnackBar('Please sign in to save trips', isError: true);
      return false;
    }

    if (endDate.isBefore(startDate)) {
      Get.context?.showAppSnackBar('End date must be after start date', isError: true);
      return false;
    }

    isLoading.value = true;
    try {
      final trip = Trip(
        id: _existingTrip?.id ?? '',
        userId: uid,
        title: title.trim(),
        destination: destination.trim(),
        description: description?.trim(),
        startDate: startDate,
        endDate: endDate,
        budget: budget,
        currency: currency,
        travelers: travelers,
        flightDetails: flightDetails?.trim(),
        hotelDetails: hotelDetails?.trim(),
        notes: notes?.trim(),
        createdAt: _existingTrip?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = isEditing.value
          ? await _tripRepository.updateTrip(trip)
          : await _tripRepository.createTrip(trip);

      if (result.isLeft()) {
        Get.context?.showAppSnackBar(
          ErrorMapper.userMessage(result.fold((f) => f, (_) => throw StateError(''))),
          isError: true,
        );
        return false;
      }

      final created = result.getOrElse(() => trip);
      if (!isEditing.value && Get.isRegistered<AnalyticsService>()) {
        await Get.find<AnalyticsService>().logTripCreated(tripId: created.id);
      }
      if (Get.isRegistered<NotificationService>()) {
        await Get.find<NotificationService>().scheduleTripReminder(
          tripId: created.id,
          title: created.title,
          destination: created.destination,
          startDate: created.startDate,
        );
        if (Get.isRegistered<AnalyticsService>()) {
          await Get.find<AnalyticsService>().logReminderScheduled(tripId: created.id);
        }
      }
      Get.context?.showAppSnackBar(
        isEditing.value ? 'Trip updated' : 'Trip created',
      );
      return true;
    } finally {
      isLoading.value = false;
    }
  }
}
