/// Global application constants.
abstract final class AppConstants {
  static const String appName = 'TravelMate AI';
  static const String organization = 'UK Solutions';
  static const String packageName = 'com.uksolutions.travelmateai';

  static const String defaultLocale = 'en';
  static const String defaultCurrency = 'USD';

  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration debounceDuration = Duration(milliseconds: 400);
  static const int minSearchQueryLength = 2;

  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String lastBackupAtKey = 'last_backup_at';

  static const double phoneMaxWidth = 600;
  static const double tabletMaxWidth = 1200;

  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeModeKey = 'theme_mode';
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String lastSyncKey = 'last_sync_at';

  static const String privacyPolicyUrl = 'https://uksolutions.com/privacy';
  static const String termsOfServiceUrl = 'https://uksolutions.com/terms';
  static const String supportEmail = 'support@uksolutions.com';
}
