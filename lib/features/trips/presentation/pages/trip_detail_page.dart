import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trip_detail_controller.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

/// Trip detail page with actions.
class TripDetailPage extends GetView<TripDetailController> {
  const TripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: AppLoadingView());
      }

      final trip = controller.trip.value;
      if (trip == null) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text('Trip not found', style: Theme.of(context).textTheme.titleMedium),
          ),
        );
      }

      final dateFormat = DateFormat('EEEE, MMM d, yyyy');

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(trip.title),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.secondaryContainer,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.flight_takeoff_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(trip.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    Get.find<TripsController>().toggleFavorite(trip.id);
                    controller.refresh();
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleAction(context, value, trip.id),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                    PopupMenuItem(value: 'archive', child: Text('Archive')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _DetailSection(
                    icon: Icons.location_on_outlined,
                    title: 'Destination',
                    value: trip.destination,
                  ),
                  _DetailSection(
                    icon: Icons.calendar_month_outlined,
                    title: 'Dates',
                    value:
                        '${dateFormat.format(trip.startDate)}\n${dateFormat.format(trip.endDate)} (${trip.durationDays} days)',
                  ),
                  _DetailSection(
                    icon: Icons.attach_money,
                    title: 'Budget',
                    value: '${trip.currency} ${trip.budget.toStringAsFixed(2)}',
                  ),
                  _DetailSection(
                    icon: Icons.people_outline,
                    title: 'Travelers',
                    value: '${trip.travelers}',
                  ),
                  if (trip.flightDetails?.isNotEmpty == true)
                    _DetailSection(
                      icon: Icons.flight_outlined,
                      title: 'Flight',
                      value: trip.flightDetails!,
                    ),
                  if (trip.hotelDetails?.isNotEmpty == true)
                    _DetailSection(
                      icon: Icons.hotel_outlined,
                      title: 'Hotel',
                      value: trip.hotelDetails!,
                    ),
                  if (trip.description?.isNotEmpty == true)
                    _DetailSection(
                      icon: Icons.description_outlined,
                      title: 'Description',
                      value: trip.description!,
                    ),
                  if (trip.notes?.isNotEmpty == true)
                    _DetailSection(
                      icon: Icons.notes_outlined,
                      title: 'Notes',
                      value: trip.notes!,
                    ),
                  if (trip.isUpcoming && trip.daysUntilStart >= 0) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            Text(
                              trip.daysUntilStart == 0
                                  ? 'Your trip starts today!'
                                  : '${trip.daysUntilStart} days until departure',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            LinearProgressIndicator(
                              value: (365 - trip.daysUntilStart.clamp(0, 365)) / 365,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.tonalIcon(
                    onPressed: () => Get.toNamed(AppRoutes.aiHub),
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('Open TravelMate AI'),
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _handleAction(BuildContext context, String action, String id) async {
    final tripsController = Get.find<TripsController>();
    switch (action) {
      case 'edit':
        final result = await Get.toNamed(
          AppRoutes.createTrip,
          arguments: controller.trip.value,
        );
        if (result == true) controller.refresh();
      case 'duplicate':
        await tripsController.duplicateTrip(id);
        controller.refresh();
      case 'archive':
        await tripsController.archiveTrip(id);
        Get.back();
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Trip'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
            ],
          ),
        );
        if (confirm == true) {
          await tripsController.deleteTrip(id);
          Get.back();
        }
    }
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
