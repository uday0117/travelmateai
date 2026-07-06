import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/expenses/presentation/pages/expenses_page.dart';
import 'package:travelmateai/features/packing/presentation/pages/packing_page.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final trips = Get.find<TripsController>();

    return Obx(() {
      final user = auth.user.value;
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage:
                  user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
              child: user?.photoUrl == null
                  ? Text(
                      user?.initials ?? 'T',
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              user?.displayName ?? 'Traveler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          if (user?.email != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                user!.email!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: _ProfileStat(label: 'Trips', value: '${trips.totalTrips}')),
              Expanded(
                child: _ProfileStat(label: 'Destinations', value: '${trips.countriesCount}'),
              ),
              Expanded(
                child: _ProfileStat(
                  label: 'Favorites',
                  value: '${trips.trips.where((t) => t.isFavorite).length}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Travel Tools',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ToolTile(
            icon: Icons.widgets_outlined,
            title: 'All Travel Tools',
            subtitle: 'Visa, weather, phrasebook, maps & more',
            onTap: () => Get.toNamed(AppRoutes.toolsHub),
          ),
          _ToolTile(
            icon: Icons.auto_awesome_outlined,
            title: 'TravelMate AI',
            subtitle: 'Planner, chat, tips & itineraries',
            onTap: () => Get.toNamed(AppRoutes.aiHub),
          ),
          _ToolTile(
            icon: Icons.receipt_long_outlined,
            title: 'Expenses',
            subtitle: 'Track spending by category',
            onTap: () => Get.to(() => const ExpensesPage()),
          ),
          _ToolTile(
            icon: Icons.folder_special_outlined,
            title: 'Document Vault',
            subtitle: 'Passport, visa, tickets & receipts',
            onTap: () => Get.toNamed(AppRoutes.documents),
          ),
          _ToolTile(
            icon: Icons.luggage_outlined,
            title: 'Packing Lists',
            subtitle: 'Smart checklists for every trip',
            onTap: () => Get.to(() => const PackingPage()),
          ),
          const Divider(height: AppSpacing.xl),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.settings),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events_outlined),
            title: const Text('Travel Stats'),
            subtitle: Text('${trips.totalTrips} trips · ${trips.countriesCount} destinations'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.travelStats),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Countries Visited'),
            subtitle: Text('${trips.countriesCount} unique destinations'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(AppRoutes.countriesVisited),
          ),
          const Divider(height: AppSpacing.xl),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () async {
              final success = await auth.signOut();
              if (success && context.mounted) Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      );
    });
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
