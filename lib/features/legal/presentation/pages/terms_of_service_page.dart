import 'package:flutter/material.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Terms of Service',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Last updated: ${DateTime.now().year}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          const _Section(
            title: 'Acceptance',
            body:
                'By using ${AppConstants.appName}, you agree to these terms. If you do not agree, '
                'please uninstall the app and discontinue use.',
          ),
          const _Section(
            title: 'Service Description',
            body:
                '${AppConstants.appName} is a free travel planning application. All core features '
                'are provided at no charge. Revenue is generated through Google AdMob advertisements.',
          ),
          const _Section(
            title: 'User Responsibilities',
            body:
                'You are responsible for the accuracy of information you enter, securing your '
                'account credentials, and complying with local laws when traveling. Do not upload '
                'illegal content or misuse AI features.',
          ),
          const _Section(
            title: 'AI Features',
            body:
                'AI suggestions are informational only and not professional travel advice. Always '
                'verify visa requirements, health guidance, and safety information with official sources.',
          ),
          const _Section(
            title: 'Limitation of Liability',
            body:
                '${AppConstants.organization} provides the app "as is" without warranties. We are not '
                'liable for travel disruptions, data loss beyond reasonable backup efforts, or '
                'third-party service outages.',
          ),
          const _Section(
            title: 'Changes',
            body:
                'We may update these terms. Continued use after changes constitutes acceptance. '
                'Contact ${AppConstants.supportEmail} with questions.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
