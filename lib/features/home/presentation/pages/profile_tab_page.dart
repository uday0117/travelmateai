import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/auth/presentation/controllers/auth_controller.dart';
import 'package:travelmateai/features/trips/presentation/controllers/trips_controller.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final trips = Get.find<TripsController>();
    final storage = Get.find<StorageService>();

    return Obx(() {
      final user = auth.user.value;
      final avatarPath = storage.profileAvatarPath;
      final displayName =
          storage.profileDisplayName ?? user?.displayName ?? 'Traveler';
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        backgroundImage:
                            avatarPath != null && avatarPath.isNotEmpty
                            ? FileImage(File(avatarPath))
                            : (user?.photoUrl != null
                                  ? NetworkImage(user!.photoUrl!)
                                  : null),
                        child: avatarPath == null && user?.photoUrl == null
                            ? Text(
                                user?.initials ?? 'T',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              )
                            : null,
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _pickAvatar(context, storage),
                        icon: const Icon(Icons.camera_alt_outlined),
                        tooltip: 'Upload profile photo',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _updateDisplayName(context, storage, user?.displayName),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit profile'),
                  ),
                  if (user?.email != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user!.email!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _ProfileStat(
                  label: 'Trips',
                  value: '${trips.totalTrips}',
                ),
              ),
              Expanded(
                child: _ProfileStat(
                  label: 'Destinations',
                  value: '${trips.countriesCount}',
                ),
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
            onTap: () => Get.toNamed(AppRoutes.expenses),
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
            onTap: () => Get.toNamed(AppRoutes.packing),
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
            subtitle: Text(
              '${trips.totalTrips} trips · ${trips.countriesCount} destinations',
            ),
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
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
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

  Future<void> _pickAvatar(BuildContext context, StorageService storage) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    await storage.setProfileAvatarPath(picked.path);
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logProfileUpdated(source: 'avatar');
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile photo updated')));
    }
  }

  Future<void> _updateDisplayName(
    BuildContext context,
    StorageService storage,
    String? currentName,
  ) async {
    final controller = TextEditingController(text: currentName ?? 'Traveler');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update profile name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == null || result.trim().isEmpty) return;
    await storage.setProfileDisplayName(result);
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logProfileUpdated(
        source: 'display_name',
      );
    }
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
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
