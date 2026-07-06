import 'package:flutter/material.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key, this.forceUpdate = false});

  final bool forceUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                forceUpdate ? Icons.system_update_alt : Icons.build_circle_outlined,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                forceUpdate ? 'Update Required' : 'Under Maintenance',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                forceUpdate
                    ? 'A newer version of ${AppConstants.appName} is available. '
                        'Please update from the Play Store to continue.'
                    : '${AppConstants.appName} is temporarily unavailable while we '
                        'perform maintenance. Please try again shortly.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              if (forceUpdate) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => _openPlayStore(),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Play Store'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPlayStore() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=${AppConstants.packageName}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
