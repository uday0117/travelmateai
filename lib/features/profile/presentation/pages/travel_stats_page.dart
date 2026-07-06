import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/explore/data/repositories/travel_stats_repository.dart';
import 'package:travelmateai/features/home/presentation/widgets/home_dashboard_widgets.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class TravelStatsPage extends StatelessWidget {
  const TravelStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = Get.find<TripsController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Travel Stats')),
      body: Obx(() {
        final userId = auth.user.value?.id;
        if (userId == null) {
          return const Center(child: Text('Sign in to view travel stats'));
        }

        return FutureBuilder(
          future: Get.find<TravelStatsRepository>().computeForUser(userId, trips.trips),
          builder: (context, snapshot) {
            final stats = snapshot.data;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  'Your travel journey at a glance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                HomeTravelStatsGrid(
                  totalTrips: stats?.totalTrips ?? trips.totalTrips,
                  countries: stats?.totalCountries ?? trips.countriesCount,
                  daysTraveled: stats?.totalDaysTraveled ?? 0,
                  totalBudget: stats?.totalExpenses ?? 0,
                ),
                const SizedBox(height: AppSpacing.lg),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.flight_takeoff_outlined),
                    title: const Text('Total trips'),
                    trailing: Text('${stats?.totalTrips ?? trips.totalTrips}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.public),
                    title: const Text('Countries visited'),
                    trailing: Text('${stats?.totalCountries ?? trips.countriesCount}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text('Days traveled'),
                    trailing: Text('${stats?.totalDaysTraveled ?? 0}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined),
                    title: const Text('Total budget planned'),
                    trailing: Text('\$${(stats?.totalExpenses ?? 0).toStringAsFixed(0)}'),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
