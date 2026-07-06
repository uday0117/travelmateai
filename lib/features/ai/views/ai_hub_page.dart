import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/ai/controllers/ai_hub_controller.dart';
import 'package:travelmateai/features/ai/models/ai_feature_type.dart';
import 'package:travelmateai/features/ai/widgets/ai_feature_tile.dart';
import 'package:travelmateai/shared/widgets/ad_banner_widget.dart';
import 'package:travelmateai/shared/widgets/app_loading_view.dart';

/// AI hub — entry point for all TravelMate AI features.
class AiHubPage extends GetView<AiHubController> {
  const AiHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelMate AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Travel Chat',
            onPressed: () => Get.toNamed(AppRoutes.aiChat),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isGenerating.value) {
          return const AppLoadingView(message: 'Generating with AI…');
        }

        final result = controller.resultContent.value;
        if (result != null) {
          return _ResultView(
            title: controller.resultTitle.value ?? 'AI Result',
            content: result,
            onBack: controller.clearResult,
          );
        }

        if (!controller.isAiEnabled) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'AI features are temporarily unavailable. Please try again later.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Text(
                    'Your AI travel companion',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Powered by Gemini — plans, tips, and chat in one place.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ...AiFeatureType.values.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AiFeatureTile(
                        feature: feature,
                        onTap: () => _onFeatureTap(feature),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const AdBannerWidget(),
          ],
        );
      }),
    );
  }

  Future<void> _onFeatureTap(AiFeatureType feature) async {
    if (feature == AiFeatureType.chat) {
      await Get.toNamed(AppRoutes.aiChat);
      return;
    }

    if (feature == AiFeatureType.itinerary && Get.isRegistered<AdMobService>()) {
      final rewarded = await Get.find<AdMobService>().showRewarded();
      if (!rewarded) return;
    }

    await controller.runFeature(feature);
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.title,
    required this.content,
    required this.onBack,
  });

  final String title;
  final String content;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SelectableText(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilledButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to AI Hub'),
            ),
          ),
        ),
      ],
    );
  }
}
