import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:travelmateai/core/theme/app_colors.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

/// Glassmorphism container for premium UI surfaces.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppSpacing.radiusLg,
    this.blur = 12,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blur;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Color(isDark ? AppColors.glassDark : AppColors.glassLight),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
