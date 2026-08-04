import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/services/analytics_service.dart';
import 'package:travelmateai/core/services/storage_service.dart';

class OnboardingController extends GetxController {
  OnboardingController(this._storageService);

  final StorageService _storageService;
  final RxInt currentPage = 0.obs;

  static const pages = [
    OnboardingPageData(
      title: 'Plan smarter trips',
      subtitle:
          'Create detailed itineraries with AI-powered suggestions tailored to your style.',
      icon: Icons.map_outlined,
    ),
    OnboardingPageData(
      title: 'Travel offline first',
      subtitle:
          'Access trips, documents, and checklists anywhere. Syncs automatically when online.',
      icon: Icons.cloud_off_outlined,
    ),
    OnboardingPageData(
      title: 'Your complete travel hub',
      subtitle:
          'Expenses, packing lists, maps, weather, and more — all in one beautiful app.',
      icon: Icons.explore_outlined,
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingComplete(true);
    if (Get.isRegistered<AnalyticsService>()) {
      await Get.find<AnalyticsService>().logOnboardingCompleted();
    }
  }
}

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
