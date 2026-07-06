import 'package:travelmateai/features/trips/domain/entities/trip.dart';

/// Reusable AI prompt templates — never embed prompts in UI widgets.
abstract final class AiPrompts {
  static const _systemTravelExpert =
      'You are TravelMate AI, a friendly and knowledgeable travel assistant. '
      'Give practical, concise advice. Use markdown formatting when helpful. '
      'Never invent visa rules or safety warnings — suggest verifying official sources.';

  static String tripPlanner({
    required String destination,
    required int durationDays,
    required int travelers,
    required String budget,
    String? travelType,
    String? notes,
  }) =>
      '''
Plan a $durationDays-day trip to $destination for $travelers traveler(s).
Budget: $budget.
${travelType != null ? 'Travel style: $travelType.' : ''}
${notes != null ? 'Notes: $notes' : ''}

Include:
1. Day-by-day overview
2. Must-see attractions
3. Local food recommendations
4. Transportation tips
5. Estimated daily budget breakdown
''';

  static String packingSuggestions({
    required String destination,
    required int durationDays,
    String? season,
    String? travelType,
  }) =>
      '''
Suggest packing items for a $durationDays-day trip to $destination.
${season != null ? 'Season: $season.' : ''}
${travelType != null ? 'Travel style: $travelType.' : ''}
Return exactly 10 essential items, one per line, no numbering or bullets.
''';

  static String budgetSuggestions({
    required Trip trip,
    required double spentSoFar,
    required int expenseCount,
  }) =>
      '''
Analyze this trip budget:
Destination: ${trip.destination}
Duration: ${trip.durationDays} days
Total budget: ${trip.currency} ${trip.budget.toStringAsFixed(2)}
Spent so far: ${trip.currency} ${spentSoFar.toStringAsFixed(2)} ($expenseCount expenses)
Travelers: ${trip.travelers}

Provide:
1. Budget health assessment
2. Category-wise spending guidance
3. 3 money-saving tips for this destination
4. Recommended daily spending limit for remaining days
''';

  static String destinationRecommendations({
    String? preferredRegion,
    String? travelStyle,
    String? budget,
    String? recentDestinations,
  }) =>
      '''
Recommend 4 travel destinations.
${preferredRegion != null ? 'Preferred region: $preferredRegion.' : ''}
${travelStyle != null ? 'Travel style: $travelStyle.' : ''}
${budget != null ? 'Budget level: $budget.' : ''}
${recentDestinations != null ? 'Already visited: $recentDestinations.' : ''}

For each destination provide:
- Name and country
- One-line reason to visit
- Best time to visit
- Estimated daily budget (USD)
Format as a numbered list.
''';

  static String dailyItinerary({required Trip trip, int? dayNumber}) {
    final day = dayNumber ?? 1;
    return '''
Create a detailed itinerary for Day $day of a trip to ${trip.destination}.
Trip dates: ${trip.startDate.toIso8601String().split('T').first} to ${trip.endDate.toIso8601String().split('T').first}.
Travelers: ${trip.travelers}.
Budget context: ${trip.currency} ${trip.budget.toStringAsFixed(2)} total.

Include morning, afternoon, and evening activities with:
- Activity name and duration
- Approximate cost
- Local tips
''';
  }

  static String travelTips({
    required String destination,
    int? daysUntilTrip,
  }) =>
      '''
Give 5 practical travel tips for visiting $destination.
${daysUntilTrip != null ? 'Trip starts in $daysUntilTrip days.' : ''}
Cover: packing, local customs, money, safety, and hidden gems.
Keep each tip to 2 sentences max.
''';

  static String chatReply({
    required String userMessage,
    String? tripContext,
  }) =>
      '''
User message: $userMessage
${tripContext != null ? 'Current trip context: $tripContext' : ''}
''';

  static String systemInstructionFor(AiPromptType type) {
    return switch (type) {
      AiPromptType.chat => _systemTravelExpert,
      _ => _systemTravelExpert,
    };
  }
}

/// Identifies which AI feature generated a prompt.
enum AiPromptType {
  tripPlanner,
  packing,
  budget,
  destinations,
  itinerary,
  travelTips,
  chat,
}
