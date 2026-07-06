import 'package:flutter/material.dart';

/// All travel tools surfaced in the Travel Tools hub.
enum TravelTool {
  visaChecker(
    id: 'visa',
    title: 'Visa Checker',
    subtitle: 'Entry requirements by passport & destination',
    icon: Icons.assignment_outlined,
  ),
  packingLists(
    id: 'packing',
    title: 'Packing Lists',
    subtitle: 'Smart checklists for every trip',
    icon: Icons.luggage_outlined,
  ),
  currencyConverter(
    id: 'currency',
    title: 'Currency Converter',
    subtitle: 'Live exchange rates & conversion',
    icon: Icons.currency_exchange,
  ),
  expenseTracker(
    id: 'expenses',
    title: 'Expense Tracker',
    subtitle: 'Track spending by category',
    icon: Icons.account_balance_wallet_outlined,
  ),
  aiAssistant(
    id: 'ai',
    title: 'AI Travel Assistant',
    subtitle: 'Plans, tips, chat & itineraries',
    icon: Icons.auto_awesome_outlined,
  ),
  weather(
    id: 'weather',
    title: 'Weather',
    subtitle: 'Current conditions & 7-day forecast',
    icon: Icons.wb_sunny_outlined,
  ),
  offlineMaps(
    id: 'maps',
    title: 'Offline Maps',
    subtitle: 'Explore destinations on the map',
    icon: Icons.map_outlined,
  ),
  phrasebook(
    id: 'phrasebook',
    title: 'Local Phrasebook',
    subtitle: 'Essential phrases in 8 languages',
    icon: Icons.translate_outlined,
  ),
  emergencyContacts(
    id: 'emergency',
    title: 'Emergency Contacts',
    subtitle: 'Police, ambulance & embassy numbers',
    icon: Icons.emergency_outlined,
  );

  const TravelTool({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}
