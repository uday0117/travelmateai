import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/theme/app_colors.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';
import 'package:travelmateai/features/splash/presentation/controllers/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              const Color(AppColors.primaryDark),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                child: Image.asset(
                  'assets/icons/splash-icon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.easeOutBack,
                    duration: 600.ms,
                  )
                  .fadeIn(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your AI travel companion',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: AppSpacing.xxl),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
