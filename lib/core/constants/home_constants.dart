import 'package:flutter/material.dart';

/// Curated content for the home dashboard and explore screens.
abstract final class HomeConstants {
  static const recentDestinationsKey = 'recent_destinations';

  static const travelTips = [
    TravelTip(
      title: 'Pack a power bank',
      body: 'Keep devices charged during long transit days.',
      icon: Icons.battery_charging_full_outlined,
    ),
    TravelTip(
      title: 'Download offline maps',
      body: 'Save your destination map before you leave Wi-Fi.',
      icon: Icons.map_outlined,
    ),
    TravelTip(
      title: 'Snap your documents',
      body: 'Store passport and visa copies in Document Vault.',
      icon: Icons.document_scanner_outlined,
    ),
    TravelTip(
      title: 'Set a daily budget',
      body: 'Track spending early to avoid overspending abroad.',
      icon: Icons.account_balance_wallet_outlined,
    ),
    TravelTip(
      title: 'Check visa rules',
      body: 'Confirm entry requirements at least 2 weeks ahead.',
      icon: Icons.assignment_outlined,
    ),
  ];

  static const aiSuggestions = [
    DestinationSuggestion(
      destination: 'Kyoto, Japan',
      country: 'Japan',
      reason: 'Cherry blossoms & serene temples',
      emoji: '🌸',
      gradient: [Color(0xFFE91E63), Color(0xFF9C27B0)],
    ),
    DestinationSuggestion(
      destination: 'Santorini, Greece',
      country: 'Greece',
      reason: 'Stunning sunsets & whitewashed villages',
      emoji: '🌅',
      gradient: [Color(0xFF2196F3), Color(0xFF00BCD4)],
    ),
    DestinationSuggestion(
      destination: 'Banff, Canada',
      country: 'Canada',
      reason: 'Alpine lakes & mountain adventures',
      emoji: '🏔️',
      gradient: [Color(0xFF4CAF50), Color(0xFF009688)],
    ),
    DestinationSuggestion(
      destination: 'Marrakech, Morocco',
      country: 'Morocco',
      reason: 'Vibrant souks & desert escapes',
      emoji: '🕌',
      gradient: [Color(0xFFFF9800), Color(0xFFF44336)],
    ),
  ];

  static const trendingDestinations = [
    ExploreDestination(
      name: 'Paris',
      country: 'France',
      category: 'Historical',
      emoji: '🗼',
      gradient: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
    ExploreDestination(
      name: 'Bali',
      country: 'Indonesia',
      category: 'Beaches',
      emoji: '🏝️',
      gradient: [Color(0xFF00897B), Color(0xFF26A69A)],
    ),
    ExploreDestination(
      name: 'Dubai',
      country: 'UAE',
      category: 'Shopping',
      emoji: '🏙️',
      gradient: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
    ),
    ExploreDestination(
      name: 'Swiss Alps',
      country: 'Switzerland',
      category: 'Mountains',
      emoji: '⛰️',
      gradient: [Color(0xFF37474F), Color(0xFF78909C)],
    ),
    ExploreDestination(
      name: 'Tokyo',
      country: 'Japan',
      category: 'Food',
      emoji: '🍣',
      gradient: [Color(0xFFC62828), Color(0xFFEF5350)],
    ),
    ExploreDestination(
      name: 'Amalfi Coast',
      country: 'Italy',
      category: 'Weekend Trips',
      emoji: '🍋',
      gradient: [Color(0xFFF57F17), Color(0xFFFFCA28)],
    ),
  ];

  static const weekendTrips = [
    ExploreDestination(
      name: 'Barcelona',
      country: 'Spain',
      category: 'Weekend',
      emoji: '🎨',
      gradient: [Color(0xFFE65100), Color(0xFFFF7043)],
    ),
    ExploreDestination(
      name: 'Prague',
      country: 'Czechia',
      category: 'Weekend',
      emoji: '🏰',
      gradient: [Color(0xFF4527A0), Color(0xFF7E57C2)],
    ),
    ExploreDestination(
      name: 'Lisbon',
      country: 'Portugal',
      category: 'Weekend',
      emoji: '🚋',
      gradient: [Color(0xFF0277BD), Color(0xFF4FC3F7)],
    ),
  ];

  static const hiddenGems = [
    ExploreDestination(
      name: 'Ljubljana',
      country: 'Slovenia',
      category: 'Hidden Gem',
      emoji: '🌿',
      gradient: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    ),
    ExploreDestination(
      name: 'Porto',
      country: 'Portugal',
      category: 'Hidden Gem',
      emoji: '🍷',
      gradient: [Color(0xFF880E4F), Color(0xFFEC407A)],
    ),
    ExploreDestination(
      name: 'Tbilisi',
      country: 'Georgia',
      category: 'Hidden Gem',
      emoji: '🏛️',
      gradient: [Color(0xFF4E342E), Color(0xFF8D6E63)],
    ),
  ];
}

class TravelTip {
  const TravelTip({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}

class DestinationSuggestion {
  const DestinationSuggestion({
    required this.destination,
    required this.country,
    required this.reason,
    required this.emoji,
    required this.gradient,
  });

  final String destination;
  final String country;
  final String reason;
  final String emoji;
  final List<Color> gradient;
}

class ExploreDestination {
  const ExploreDestination({
    required this.name,
    required this.country,
    required this.category,
    required this.emoji,
    required this.gradient,
  });

  final String name;
  final String country;
  final String category;
  final String emoji;
  final List<Color> gradient;
}
