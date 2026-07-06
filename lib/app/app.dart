import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_pages.dart';
import 'package:travelmateai/core/constants/app_constants.dart';
import 'package:travelmateai/core/services/admob_service.dart';
import 'package:travelmateai/core/theme/app_theme.dart';
import 'package:travelmateai/core/theme/theme_controller.dart';

/// Root application widget with app-open ad lifecycle handling.
class TravelMateApp extends StatefulWidget {
  const TravelMateApp({super.key});

  @override
  State<TravelMateApp> createState() => _TravelMateAppState();
}

class _TravelMateAppState extends State<TravelMateApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!Get.isRegistered<AdMobService>()) return;
    final ads = Get.find<AdMobService>();

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ads.onAppBackgrounded();
      case AppLifecycleState.resumed:
        ads.showAppOpenAdIfAvailable();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeController.themeMode.value,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        defaultTransition: Transition.cupertino,
        locale: const Locale(AppConstants.defaultLocale),
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
