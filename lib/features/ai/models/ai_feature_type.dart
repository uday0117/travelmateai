import 'package:flutter/material.dart';

/// Available AI features in the TravelMate AI hub.
enum AiFeatureType {
  tripPlanner(
    title: 'Trip Planner',
    subtitle: 'Full itinerary from your preferences',
    icon: Icons.map_outlined,
  ),
  packing(
    title: 'Packing Assistant',
    subtitle: 'Smart packing list for your trip',
    icon: Icons.luggage_outlined,
  ),
  budget(
    title: 'Budget Advisor',
    subtitle: 'Spending analysis and savings tips',
    icon: Icons.account_balance_wallet_outlined,
  ),
  destinations(
    title: 'Destination Ideas',
    subtitle: 'Personalized place recommendations',
    icon: Icons.explore_outlined,
  ),
  itinerary(
    title: 'Daily Itinerary',
    subtitle: 'Hour-by-hour plan for each day',
    icon: Icons.event_note_outlined,
  ),
  travelTips(
    title: 'Travel Tips',
    subtitle: 'Local insights before you go',
    icon: Icons.lightbulb_outline,
  ),
  chat(
    title: 'Travel Chat',
    subtitle: 'Ask anything about your trip',
    icon: Icons.chat_bubble_outline,
  );

  const AiFeatureType({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
