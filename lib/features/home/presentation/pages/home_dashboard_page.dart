import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/constants/home_constants.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/expenses/presentation/controllers/expenses_controller.dart';
import 'package:travelmateai/features/expenses/presentation/pages/expenses_page.dart';
import 'package:travelmateai/features/home/presentation/controllers/home_controller.dart';
import 'package:travelmateai/features/home/presentation/widgets/home_dashboard_widgets.dart';
import 'package:travelmateai/features/journal/presentation/pages/journal_page.dart';
import 'package:travelmateai/features/packing/presentation/pages/packing_page.dart';
import 'package:travelmateai/features/trips/domain/entities/trip.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';
import 'package:travelmateai/features/trips/presentation/widgets/trip_card.dart';
import 'package:travelmateai/shared/widgets/ad_banner_widget.dart';
import 'package:travelmateai/shared/widgets/glass_container.dart';
import 'package:travelmateai/shared/widgets/responsive_layout.dart';

/// Google Travel–inspired home dashboard with all travel-at-a-glance sections.
class HomeDashboardPage extends GetView<HomeController> {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = Get.find<TripsController>();

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ResponsiveLayout(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeWelcomeHeader().animate().fadeIn(),
                    const SizedBox(height: AppSpacing.lg),
                    _SearchBar(
                      onTap: () => Get.toNamed(AppRoutes.search),
                    ).animate().fadeIn(delay: 80.ms).slideY(begin: 0.08),
                    const SizedBox(height: AppSpacing.lg),

                    // Active trip hero
                    Obx(() {
                      final active = trips.activeTrips;
                      if (active.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeSectionHeader(title: 'Active Trip'),
                          const SizedBox(height: AppSpacing.sm),
                          _ActiveTripHero(trip: active.first),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      );
                    }),

                    // Weather + Currency
                    _WeatherCurrencySection(),
                    const SizedBox(height: AppSpacing.lg),

                    // Quick Actions
                    const HomeSectionHeader(title: 'Quick Actions'),
                    const SizedBox(height: AppSpacing.md),
                    _QuickActionsGrid(),
                    const SizedBox(height: AppSpacing.lg),

                    // Upcoming Trips
                    HomeSectionHeader(
                      title: 'Upcoming Trips',
                      actionLabel: 'See all',
                      onAction: () => controller.changeTab(1),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Obx(() => _TripSection(
                          trips: trips.upcomingTrips,
                          emptyTitle: 'No upcoming trips',
                          emptySubtitle:
                              'Create your first trip and let AI plan the perfect itinerary.',
                        )),
                    const SizedBox(height: AppSpacing.lg),

                    // Continue Planning
                    Obx(() {
                      final planning = trips.planningTrips;
                      if (planning.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeSectionHeader(title: 'Continue Planning'),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Finish setting up these trips',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ...planning.take(2).map(
                                (trip) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                  child: _PlanningCard(trip: trip),
                                ),
                              ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      );
                    }),

                    // Recent Trips
                    HomeSectionHeader(
                      title: 'Recent Trips',
                      actionLabel: 'See all',
                      onAction: () => controller.changeTab(1),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Obx(() => _HorizontalTripList(trips: trips.recentTrips)),
                    const SizedBox(height: AppSpacing.lg),

                    // Travel Tips
                    const HomeSectionHeader(title: 'Travel Tips'),
                    const SizedBox(height: AppSpacing.md),
                    HomeTravelTipsRow(tips: controller.travelTips),
                    const SizedBox(height: AppSpacing.lg),

                    // Recently Visited Places
                    Obx(() {
                      final places = controller.visitedPlaces;
                      if (places.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeSectionHeader(title: 'Recently Visited Places'),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: places.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, i) {
                                final place = places[i];
                                return Chip(
                                  avatar: const Icon(Icons.place_outlined, size: 18),
                                  label: Text('${place.name}, ${place.country}'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      );
                    }),

                    // Recently Viewed Destinations
                    Obx(() {
                      final recent = controller.recentDestinations;
                      if (recent.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeSectionHeader(title: 'Recently Viewed'),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: recent.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, i) {
                                final dest = recent[i];
                                return HomeDestinationCard(
                                  title: dest.split(',').first.trim(),
                                  subtitle: dest.contains(',')
                                      ? dest.split(',').last.trim()
                                      : 'Destination',
                                  emoji: '📍',
                                  gradient: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                  onTap: () => Get.toNamed(AppRoutes.createTrip),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      );
                    }),

                    // AI Suggestions
                    const HomeSectionHeader(title: 'AI Suggestions'),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Destinations picked for you',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: HomeConstants.aiSuggestions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final s = HomeConstants.aiSuggestions[i];
                          return HomeDestinationCard(
                            title: s.destination,
                            subtitle: s.reason,
                            emoji: s.emoji,
                            gradient: s.gradient,
                            onTap: () {
                              controller.recordDestinationView(s.destination);
                              Get.toNamed(AppRoutes.createTrip);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Travel Statistics
                    const HomeSectionHeader(title: 'Travel Statistics'),
                    const SizedBox(height: AppSpacing.md),
                    Obx(() {
                      final stats = controller.travelStats.value;
                      return HomeTravelStatsGrid(
                        totalTrips: stats?.totalTrips ?? trips.totalTrips,
                        countries: stats?.totalCountries ?? trips.countriesCount,
                        daysTraveled: stats?.totalDaysTraveled ?? 0,
                        totalBudget: stats?.totalExpenses ?? 0,
                      );
                    }),
                    const SizedBox(height: AppSpacing.lg),

                    // Banner Ad
                    const Center(child: AdBannerWidget()),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Search trips, destinations, journal…',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            Icon(
              Icons.tune_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveTripHero extends StatelessWidget {
  const _ActiveTripHero({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final daysLeft = trip.endDate.difference(DateTime.now()).inDays + 1;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.tripDetail, arguments: trip),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Text(
                  '● LIVE NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                trip.destination,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                trip.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherCurrencySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    final expenses =
        Get.isRegistered<ExpensesController>() ? Get.find<ExpensesController>() : null;

    return Obx(() {
      final weather = home.weather.value;
      final rates = home.currencyRates;
      final eurRate = rates['EUR'];

      return Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.wb_sunny_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Weather', style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      weather != null
                          ? '${weather.temperature.toStringAsFixed(0)}°C · ${weather.description}'
                          : 'Loading…',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (weather != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${weather.city} · ${weather.humidity}% humidity',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Currency', style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      eurRate != null ? '1 USD = ${eurRate.toStringAsFixed(2)} EUR' : 'Loading…',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Obx(
                      () => Text(
                        '\$${expenses?.total.toStringAsFixed(0) ?? '0'} spent',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.45,
      children: [
        _QuickAction(
          icon: Icons.add_location_alt_outlined,
          label: 'New Trip',
          color: Theme.of(context).colorScheme.primaryContainer,
          onTap: () => Get.toNamed(AppRoutes.createTrip),
        ),
        _QuickAction(
          icon: Icons.auto_awesome_outlined,
          label: 'AI Itinerary',
          color: Theme.of(context).colorScheme.secondaryContainer,
          onTap: () => Get.toNamed(AppRoutes.aiHub),
        ),
        _QuickAction(
          icon: Icons.luggage_outlined,
          label: 'Packing',
          color: Theme.of(context).colorScheme.tertiaryContainer,
          onTap: () => Get.to(() => const PackingPage()),
        ),
        _QuickAction(
          icon: Icons.menu_book_outlined,
          label: 'Journal',
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          onTap: () => Get.to(() => const JournalPage()),
        ),
        _QuickAction(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Expenses',
          color: Theme.of(context).colorScheme.secondaryContainer,
          onTap: () => Get.to(() => const ExpensesPage()),
        ),
        _QuickAction(
          icon: Icons.widgets_outlined,
          label: 'Travel Tools',
          color: Theme.of(context).colorScheme.primaryContainer,
          onTap: () => Get.toNamed(AppRoutes.toolsHub),
        ),
        _QuickAction(
          icon: Icons.explore_outlined,
          label: 'Explore',
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          onTap: () => Get.find<HomeController>().changeTab(2),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.55),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26),
              const Spacer(),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripSection extends StatelessWidget {
  const _TripSection({
    required this.trips,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  final List<Trip> trips;
  final String emptyTitle;
  final String emptySubtitle;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Icon(
                Icons.flight_takeoff_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(emptyTitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                emptySubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.createTrip),
                icon: const Icon(Icons.add),
                label: const Text('Create Trip'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: trips
          .take(3)
          .map(
            (trip) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: TripCard(trip: trip, showCountdown: true),
            ),
          )
          .toList(),
    );
  }
}

class _HorizontalTripList extends StatelessWidget {
  const _HorizontalTripList({required this.trips});
  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Text(
        'Your recent trips will appear here',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          final trip = trips[i];
          return SizedBox(
            width: 280,
            child: TripCard(trip: trip, showCountdown: false),
          );
        },
      ),
    );
  }
}

class _PlanningCard extends StatelessWidget {
  const _PlanningCard({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final missing = <String>[];
    if (trip.budget <= 0) missing.add('budget');
    if (trip.flightDetails == null || trip.flightDetails!.isEmpty) {
      missing.add('flights');
    }
    if (trip.hotelDetails == null || trip.hotelDetails!.isEmpty) {
      missing.add('hotel');
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.edit_calendar_outlined),
        ),
        title: Text(trip.title),
        subtitle: Text(
          'Add ${missing.join(', ')} · ${DateFormat('MMM d').format(trip.startDate)}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Get.toNamed(AppRoutes.tripDetail, arguments: trip),
      ),
    );
  }
}
