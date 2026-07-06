import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:travelmateai/core/constants/analytics_constants.dart';
import 'package:travelmateai/core/logging/app_logger.dart';

/// Firebase Analytics wrapper with typed travel events.
class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e, st) {
      AppLogger.warning('Analytics screen view failed', e, st);
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e, st) {
      AppLogger.warning('Analytics event failed', e, st);
    }
  }

  Future<void> logAppOpen() => logEvent(name: AnalyticsEvents.appOpen);

  Future<void> logLogin({required String method}) => logEvent(
        name: AnalyticsEvents.login,
        parameters: {AnalyticsParams.method: method},
      );

  Future<void> logTripCreated({required String tripId}) => logEvent(
        name: AnalyticsEvents.tripCreated,
        parameters: {AnalyticsParams.tripId: tripId},
      );

  Future<void> logTripDeleted({required String tripId}) => logEvent(
        name: AnalyticsEvents.tripDeleted,
        parameters: {AnalyticsParams.tripId: tripId},
      );

  Future<void> logExpenseAdded({String? tripId}) => logEvent(
        name: AnalyticsEvents.expenseAdded,
        parameters: tripId != null ? {AnalyticsParams.tripId: tripId} : null,
      );

  Future<void> logPackingCompleted({String? tripId}) => logEvent(
        name: AnalyticsEvents.packingCompleted,
        parameters: tripId != null ? {AnalyticsParams.tripId: tripId} : null,
      );

  Future<void> logJournalCreated({String? tripId}) => logEvent(
        name: AnalyticsEvents.journalCreated,
        parameters: tripId != null ? {AnalyticsParams.tripId: tripId} : null,
      );

  Future<void> logDocumentUploaded() =>
      logEvent(name: AnalyticsEvents.documentUploaded);

  Future<void> logSearchUsed({
    required String query,
    required int resultCount,
  }) =>
      logEvent(
        name: AnalyticsEvents.searchUsed,
        parameters: {
          AnalyticsParams.query: query,
          AnalyticsParams.resultCount: resultCount,
        },
      );

  Future<void> logMapOpened() => logEvent(name: AnalyticsEvents.mapOpened);

  Future<void> logWeatherViewed({required String city}) => logEvent(
        name: AnalyticsEvents.weatherViewed,
        parameters: {AnalyticsParams.query: city},
      );

  Future<void> logCurrencyConverted({
    required String from,
    required String to,
  }) =>
      logEvent(
        name: AnalyticsEvents.currencyConverted,
        parameters: {
          AnalyticsParams.fromCurrency: from,
          AnalyticsParams.toCurrency: to,
        },
      );

  Future<void> logAiUsed({required String feature}) => logEvent(
        name: AnalyticsEvents.aiUsed,
        parameters: {AnalyticsParams.feature: feature},
      );

  Future<void> logAdClicked({required String adType}) => logEvent(
        name: AnalyticsEvents.adClicked,
        parameters: {AnalyticsParams.adType: adType},
      );
}
