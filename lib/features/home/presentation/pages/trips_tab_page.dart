import 'package:flutter/material.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';

class TripsTabPage extends StatelessWidget {
  const TripsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppEmptyView(
      title: 'Your Trips',
      subtitle: 'All your adventures in one place. Coming in Phase 2.',
      icon: Icons.card_travel_outlined,
      actionLabel: 'Create Trip',
    );
  }
}
