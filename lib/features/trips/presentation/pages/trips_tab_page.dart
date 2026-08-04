import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:travelmateai/features/trips/presentation/widgets/trip_card.dart';
import 'package:travelmateai/shared/widgets/app_empty_view.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

class TripsTabPage extends GetView<TripsController> {
  const TripsTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.favoritesOnly.value ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: controller.favoritesOnly.toggle,
              tooltip: 'Favorites',
            ),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.showArchived.value ? Icons.archive : Icons.archive_outlined,
              ),
              onPressed: controller.showArchived.toggle,
              tooltip: 'Archived',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.createTrip);
          if (result == true) controller.loadTrips();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              onChanged: (v) => controller.searchQuery.value = v,
              decoration: InputDecoration(
                hintText: 'Search trips...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.searchQuery.value = '',
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.trips.isEmpty) {
                return const AppLoadingView();
              }

              if (controller.trips.isEmpty) {
                return AppEmptyView(
                  title: controller.showArchived.value
                      ? 'No archived trips'
                      : 'No trips yet',
                  subtitle: controller.showArchived.value
                      ? 'Archived trips will appear here.'
                      : 'Create your first adventure and start planning.',
                  icon: Icons.card_travel_outlined,
                  actionLabel: 'Create Trip',
                  onAction: () => Get.toNamed(AppRoutes.createTrip),
                  tip: controller.showArchived.value
                      ? 'Tips: archive trips you no longer need to keep the list tidy.'
                      : 'Tip: add a few trip details so TravelMate AI can help you plan smarter.',
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    100,
                  ),
                  itemCount: controller.trips.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final trip = controller.trips[index];
                    return TripCard(trip: trip)
                        .animate(delay: (50 * index).ms)
                        .fadeIn()
                        .slideY(begin: 0.05);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
