/// Firebase Analytics event and parameter names.
abstract final class AnalyticsEvents {
  static const appOpen = 'app_open';
  static const login = 'login';
  static const tripCreated = 'trip_created';
  static const tripDeleted = 'trip_deleted';
  static const expenseAdded = 'expense_added';
  static const packingCompleted = 'packing_completed';
  static const journalCreated = 'journal_created';
  static const documentUploaded = 'document_uploaded';
  static const searchUsed = 'search_used';
  static const mapOpened = 'map_opened';
  static const weatherViewed = 'weather_viewed';
  static const currencyConverted = 'currency_converted';
  static const aiUsed = 'ai_used';
  static const onboardingCompleted = 'onboarding_completed';
  static const profileUpdated = 'profile_updated';
  static const dataExported = 'data_exported';
  static const reminderScheduled = 'reminder_scheduled';
  static const adClicked = 'ad_clicked';
}

abstract final class AnalyticsParams {
  static const method = 'method';
  static const tripId = 'trip_id';
  static const query = 'query';
  static const resultCount = 'result_count';
  static const feature = 'feature';
  static const source = 'source';
  static const adType = 'ad_type';
  static const fromCurrency = 'from_currency';
  static const toCurrency = 'to_currency';
}
