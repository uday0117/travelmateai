import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/expenses/presentation/pages/expenses_page.dart';
import 'package:travelmateai/features/maps/presentation/pages/maps_page.dart';
import 'package:travelmateai/features/packing/presentation/pages/packing_page.dart';
import 'package:travelmateai/features/tools/models/travel_tool.dart';
import 'package:travelmateai/features/tools/presentation/pages/currency_page.dart';
import 'package:travelmateai/features/tools/presentation/pages/emergency_contacts_page.dart';
import 'package:travelmateai/features/tools/presentation/pages/phrasebook_page.dart';
import 'package:travelmateai/features/tools/presentation/pages/visa_checker_page.dart';
import 'package:travelmateai/features/tools/presentation/pages/weather_page.dart';

/// Central hub for all travel utility features.
class ToolsHubPage extends StatelessWidget {
  const ToolsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel Tools')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Everything you need on the road',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Visa rules, packing, money, safety & more — all in one place.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...TravelTool.values.map(
            (tool) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ToolCard(tool: tool, onTap: () => _openTool(tool)),
            ),
          ),
        ],
      ),
    );
  }

  void _openTool(TravelTool tool) {
    switch (tool) {
      case TravelTool.visaChecker:
        Get.to(() => const VisaCheckerPage());
      case TravelTool.packingLists:
        Get.to(() => const PackingPage());
      case TravelTool.currencyConverter:
        Get.to(() => const CurrencyPage());
      case TravelTool.expenseTracker:
        Get.to(() => const ExpensesPage());
      case TravelTool.aiAssistant:
        Get.toNamed(AppRoutes.aiHub);
      case TravelTool.weather:
        Get.to(() => const WeatherPage());
      case TravelTool.offlineMaps:
        Get.to(() => const MapsPage());
      case TravelTool.phrasebook:
        Get.to(() => const PhrasebookPage());
      case TravelTool.emergencyContacts:
        Get.to(() => const EmergencyContactsPage());
    }
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({required this.tool, required this.onTap});

  final TravelTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tool.icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      tool.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
