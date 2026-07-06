import 'package:flutter/material.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Privacy Policy',
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
            title: 'Overview',
            body:
                '${AppConstants.appName} by ${AppConstants.organization} helps you plan trips, '
                'track expenses, and store travel documents. This policy explains what data we '
                'collect and how we use it.',
          ),
          const _Section(
            title: 'Data We Collect',
            body:
                'Account information (email, display name), trip data, journal entries, '
                'expenses, packing lists, uploaded documents, device identifiers for analytics, '
                'and crash reports. Location is used only when you open maps or weather features.',
          ),
          const _Section(
            title: 'How We Use Data',
            body:
                'We use your data to provide app features, sync across devices via Firebase, '
                'improve reliability, show relevant ads through Google AdMob, and send optional '
                'trip reminders when notifications are enabled.',
          ),
          const _Section(
            title: 'Third-Party Services',
            body:
                'We use Firebase (Auth, Firestore, Storage, Analytics, Crashlytics, Remote Config, '
                'FCM), Google AdMob, Google Maps, and AI providers configured in your environment. '
                'Each service has its own privacy policy.',
          ),
          const _Section(
            title: 'Your Choices',
            body:
                'You can sign out, delete your account from Settings, disable notifications, '
                'and request data deletion by contacting ${AppConstants.supportEmail}.',
          ),
          const _Section(
            title: 'Contact',
            body:
                'Questions about this policy? Email ${AppConstants.supportEmail} or visit '
                '${AppConstants.privacyPolicyUrl}.',
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
