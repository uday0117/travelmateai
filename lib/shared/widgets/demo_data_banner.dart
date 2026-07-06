import 'package:flutter/material.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

/// Shown when a feature falls back to sample data because an API key is missing.
class DemoDataBanner extends StatelessWidget {
  const DemoDataBanner({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      content: Row(
        children: [
          Icon(
            Icons.science_outlined,
            size: 20,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
