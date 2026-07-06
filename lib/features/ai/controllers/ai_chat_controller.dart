import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/extensions/context_extensions.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/features/ai/models/ai_chat_message.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:uuid/uuid.dart';

class AiChatController extends GetxController {
  AiChatController(this._aiService);

  final AiService _aiService;
  final RxList<AiChatMessage> messages = <AiChatMessage>[].obs;
  final RxBool isSending = false.obs;
  final textController = TextEditingController();

  Trip? get _activeTrip {
    if (!Get.isRegistered<TripsController>()) return null;
    final trips = Get.find<TripsController>();
    return trips.activeTrips.firstOrNull ?? trips.upcomingTrips.firstOrNull;
  }

  String? get _tripContext {
    final trip = _activeTrip;
    if (trip == null) return null;
    return '${trip.title} to ${trip.destination}, '
        '${trip.durationDays} days, budget ${trip.currency} ${trip.budget}';
  }

  @override
  void onInit() {
    super.onInit();
    messages.add(
      AiChatMessage(
        id: const Uuid().v4(),
        role: AiMessageRole.assistant,
        content: 'Hi! I\'m TravelMate AI. Ask me about destinations, '
            'packing, budgets, or anything travel-related.',
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> sendMessage([String? text]) async {
    final content = (text ?? textController.text).trim();
    if (content.isEmpty || isSending.value) return;

    textController.clear();
    messages.add(
      AiChatMessage(
        id: const Uuid().v4(),
        role: AiMessageRole.user,
        content: content,
        timestamp: DateTime.now(),
      ),
    );

    final placeholderId = const Uuid().v4();
    messages.add(
      AiChatMessage(
        id: placeholderId,
        role: AiMessageRole.assistant,
        content: '',
        timestamp: DateTime.now(),
        isLoading: true,
      ),
    );

    isSending.value = true;
    try {
      final reply = await _aiService.chat(
        userMessage: content,
        tripContext: _tripContext,
      );
      final index = messages.indexWhere((m) => m.id == placeholderId);
      if (index >= 0) {
        messages[index] = messages[index].copyWith(
          content: reply,
          isLoading: false,
        );
      }
      if (Get.isRegistered<AnalyticsService>()) {
        await Get.find<AnalyticsService>().logAiUsed(feature: 'travel_chat');
      }
    } catch (e) {
      messages.removeWhere((m) => m.id == placeholderId);
      Get.context?.showAppSnackBar(
        ErrorMapper.userMessage(ErrorMapper.mapException(e)),
        isError: true,
      );
    } finally {
      isSending.value = false;
    }
  }
}
