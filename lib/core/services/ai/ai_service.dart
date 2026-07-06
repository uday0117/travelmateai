import 'package:get/get.dart';
import 'package:travelmateai/core/errors/error_mapper.dart';
import 'package:travelmateai/core/errors/exceptions.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/ai/ai_prompts.dart';
import 'package:travelmateai/core/services/ai/ai_provider.dart';
import 'package:travelmateai/core/services/remote_config_service.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';

/// Centralized AI service — all Gemini calls go through here.
class AiService extends GetxService {
  AiService(this._provider);

  final AiProvider _provider;

  bool get isAvailable {
    if (Get.isRegistered<RemoteConfigService>()) {
      return Get.find<RemoteConfigService>().enableAiFeatures;
    }
    return true;
  }

  Future<String> planTrip({
    required String destination,
    required int durationDays,
    required int travelers,
    required String budget,
    String? travelType,
    String? notes,
  }) =>
      _complete(
        AiPromptType.tripPlanner,
        AiPrompts.tripPlanner(
          destination: destination,
          durationDays: durationDays,
          travelers: travelers,
          budget: budget,
          travelType: travelType,
          notes: notes,
        ),
        maxTokens: 4096,
      );

  Future<List<String>> suggestPacking({
    required String destination,
    required int durationDays,
    String? season,
    String? travelType,
  }) async {
    final text = await _complete(
      AiPromptType.packing,
      AiPrompts.packingSuggestions(
        destination: destination,
        durationDays: durationDays,
        season: season,
        travelType: travelType,
      ),
      temperature: 0.5,
    );
    return text
        .split('\n')
        .map((l) => l.replaceAll(RegExp(r'^[\d\.\-\*]+\s*'), '').trim())
        .where((l) => l.isNotEmpty)
        .take(12)
        .toList();
  }

  Future<String> suggestBudget({
    required Trip trip,
    required double spentSoFar,
    required int expenseCount,
  }) =>
      _complete(
        AiPromptType.budget,
        AiPrompts.budgetSuggestions(
          trip: trip,
          spentSoFar: spentSoFar,
          expenseCount: expenseCount,
        ),
      );

  Future<String> recommendDestinations({
    String? preferredRegion,
    String? travelStyle,
    String? budget,
    String? recentDestinations,
  }) =>
      _complete(
        AiPromptType.destinations,
        AiPrompts.destinationRecommendations(
          preferredRegion: preferredRegion,
          travelStyle: travelStyle,
          budget: budget,
          recentDestinations: recentDestinations,
        ),
      );

  Future<String> generateDailyItinerary({
    required Trip trip,
    int dayNumber = 1,
  }) =>
      _complete(
        AiPromptType.itinerary,
        AiPrompts.dailyItinerary(trip: trip, dayNumber: dayNumber),
        maxTokens: 4096,
      );

  Future<String> generateTravelTips({
    required String destination,
    int? daysUntilTrip,
  }) =>
      _complete(
        AiPromptType.travelTips,
        AiPrompts.travelTips(
          destination: destination,
          daysUntilTrip: daysUntilTrip,
        ),
      );

  Future<String> chat({
    required String userMessage,
    String? tripContext,
  }) =>
      _complete(
        AiPromptType.chat,
        AiPrompts.chatReply(userMessage: userMessage, tripContext: tripContext),
      );

  Future<String> _complete(
    AiPromptType type,
    String prompt, {
    double temperature = 0.7,
    int maxTokens = 2048,
  }) async {
    if (!isAvailable) {
      throw const ServerException('AI features are currently disabled');
    }

    try {
      final response = await _provider.complete(
        AiRequest(
          prompt: prompt,
          systemInstruction: AiPrompts.systemInstructionFor(type),
          temperature: temperature,
          maxTokens: maxTokens,
        ),
      );
      return response.text.trim();
    } catch (e, st) {
      AppLogger.error('AI request failed ($type)', e, st);
      if (e is ServerException) rethrow;
      throw ServerException(ErrorMapper.userMessage(ErrorMapper.mapException(e)));
    }
  }
}
