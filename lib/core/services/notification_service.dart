import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:travelmateai/core/logging/app_logger.dart';
import 'package:travelmateai/core/services/firebase_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? localNotifications})
      : _localNotifications = localNotifications ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _localNotifications;
  bool _localInitialized = false;

  Future<void> init() async {
    tz_data.initializeTimeZones();
    await _initLocalNotifications();

    if (!FirebaseService.isInitialized) return;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      if (kDebugMode) {
        final token = await messaging.getToken();
        AppLogger.debug('FCM token acquired');
        if (token != null) AppLogger.debug('FCM token length: ${token.length}');
      }
      FirebaseMessaging.onMessage.listen((message) {
        AppLogger.debug('Foreground notification: ${message.notification?.title}');
      });
    } catch (e, st) {
      AppLogger.warning('Notification init failed', e, st);
    }
  }

  Future<void> _initLocalNotifications() async {
    if (_localInitialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _localInitialized = true;
  }

  Future<bool> requestPermission() async {
    await _initLocalNotifications();
    if (FirebaseService.isInitialized) {
      try {
        final settings = await FirebaseMessaging.instance.requestPermission();
        return settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;
      } catch (e, st) {
        AppLogger.warning('Notification permission failed', e, st);
      }
    }
    return true;
  }

  Future<void> scheduleTripReminder({
    required String tripId,
    required String title,
    required String destination,
    required DateTime startDate,
  }) async {
    await _initLocalNotifications();

    final reminderAt = DateTime(
      startDate.year,
      startDate.month,
      startDate.day - 1,
      9,
    );
    if (reminderAt.isBefore(DateTime.now())) return;

    final id = _notificationIdFor(tripId);
    await _localNotifications.zonedSchedule(
      id,
      'Trip tomorrow: $destination',
      '$title starts on ${_formatDate(startDate)}. Final packing check!',
      tz.TZDateTime.from(reminderAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trip_reminders',
          'Trip Reminders',
          channelDescription: 'Reminders before your trips start',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelTripReminder(String tripId) async {
    await _localNotifications.cancel(_notificationIdFor(tripId));
  }

  Future<void> cancelAllLocal() async {
    await _localNotifications.cancelAll();
  }

  int _notificationIdFor(String tripId) => tripId.hashCode.abs() % 100000;

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
