import 'package:get/get.dart';
import 'package:travelmateai/app/routes/app_routes.dart';
import 'package:travelmateai/features/auth/presentation/bindings/auth_binding.dart';
import 'package:travelmateai/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:travelmateai/features/auth/presentation/pages/login_page.dart';
import 'package:travelmateai/features/auth/presentation/pages/register_page.dart';
import 'package:travelmateai/features/home/presentation/bindings/home_binding.dart';
import 'package:travelmateai/features/home/presentation/pages/main_shell_page.dart';
import 'package:travelmateai/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:travelmateai/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:travelmateai/features/settings/presentation/bindings/settings_binding.dart';
import 'package:travelmateai/features/settings/presentation/pages/settings_page.dart';
import 'package:travelmateai/features/splash/presentation/bindings/splash_binding.dart';
import 'package:travelmateai/features/splash/presentation/pages/splash_page.dart';
import 'package:travelmateai/features/trips/presentation/bindings/trips_binding.dart';
import 'package:travelmateai/features/trips/presentation/pages/create_trip_page.dart';
import 'package:travelmateai/features/trips/presentation/pages/trip_detail_page.dart';
import 'package:travelmateai/features/expenses/presentation/bindings/expenses_binding.dart';
import 'package:travelmateai/features/expenses/presentation/pages/expenses_page.dart';
import 'package:travelmateai/features/journal/presentation/controllers/journal_controller.dart';
import 'package:travelmateai/features/journal/presentation/pages/journal_page.dart';
import 'package:travelmateai/features/ai/bindings/ai_binding.dart';
import 'package:travelmateai/features/ai/views/ai_chat_page.dart';
import 'package:travelmateai/features/ai/views/ai_hub_page.dart';
import 'package:travelmateai/features/documents/presentation/controllers/documents_controller.dart';
import 'package:travelmateai/features/documents/presentation/pages/document_vault_page.dart';
import 'package:travelmateai/features/packing/presentation/controllers/packing_controller.dart';
import 'package:travelmateai/features/packing/presentation/pages/packing_page.dart';
import 'package:travelmateai/features/legal/presentation/pages/privacy_policy_page.dart';
import 'package:travelmateai/features/legal/presentation/pages/terms_of_service_page.dart';
import 'package:travelmateai/features/maps/presentation/pages/maps_page.dart';
import 'package:travelmateai/features/search/presentation/bindings/search_binding.dart';
import 'package:travelmateai/features/search/presentation/pages/global_search_page.dart';
import 'package:travelmateai/features/tools/presentation/pages/tools_hub_page.dart';
import 'package:travelmateai/features/profile/presentation/pages/travel_stats_page.dart';
import 'package:travelmateai/features/profile/presentation/pages/countries_visited_page.dart';

/// GetX route definitions with lazy bindings.
abstract final class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainShellPage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.createTrip,
      page: () => const CreateTripPage(),
      binding: TripFormBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.tripDetail,
      page: () => const TripDetailPage(),
      binding: TripDetailBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.expenses,
      page: () => const ExpensesPage(),
      binding: ExpensesBinding(),
    ),
    GetPage(
      name: AppRoutes.packing,
      page: () => const PackingPage(),
      binding: PackingBinding(),
    ),
    GetPage(
      name: AppRoutes.journal,
      page: () => const JournalPage(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: AppRoutes.documents,
      page: () => const DocumentVaultPage(),
      binding: DocumentsBinding(),
    ),
    GetPage(
      name: AppRoutes.aiHub,
      page: () => const AiHubPage(),
      binding: AiBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.aiChat,
      page: () => const AiChatPage(),
      binding: AiBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const GlobalSearchPage(),
      binding: SearchBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.maps,
      page: () => const MapsPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.toolsHub,
      page: () => const ToolsHubPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.travelStats,
      page: () => const TravelStatsPage(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.countriesVisited,
      page: () => const CountriesVisitedPage(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.termsOfService,
      page: () => const TermsOfServicePage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
