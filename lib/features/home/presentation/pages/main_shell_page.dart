import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/features/home/presentation/controllers/home_controller.dart';
import 'package:travelmateai/features/home/presentation/pages/explore_tab_page.dart';
import 'package:travelmateai/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:travelmateai/features/home/presentation/pages/journal_tab_page.dart';
import 'package:travelmateai/features/home/presentation/pages/profile_tab_page.dart';
import 'package:travelmateai/features/trips/presentation/pages/trips_tab_page.dart';

/// Main shell — Home, Trips, Explore, Journal, Profile.
class MainShellPage extends GetView<HomeController> {
  const MainShellPage({super.key});

  static const _pages = [
    HomeDashboardPage(),
    TripsTabPage(),
    ExploreTabPage(),
    JournalTabPage(),
    ProfileTabPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: (index) {
            controller.changeTab(index);
            if (index == 2 && Get.isRegistered<AdMobService>()) {
              Get.find<AdMobService>().showInterstitial();
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.card_travel_outlined),
              selectedIcon: Icon(Icons.card_travel),
              label: 'Trips',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Journal',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
