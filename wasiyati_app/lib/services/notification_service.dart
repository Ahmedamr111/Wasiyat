import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}

/// Unified notification service managing FCM and local check-in reminders
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'Wasiyati Notifications';
  static const String _channelDesc = 'Important legacy preservation notifications';

  /// Initialize Firebase Messaging, Local Notifications, and Timezones
  Future<void> initialize() async {
    // 1. Request FCM Permission (particularly for Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Set up background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Initialize Local Notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android High Importance Channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // 4. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(notification);
      }
    });

    // 5. Handle App Opened from Notification
    // When app is terminated:
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    // When app is in background but active:
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // 6. Initialize Timezones for scheduling
    tz.initializeTimeZones();

    // 7. Schedule default daily check-in reminder at 9:00 AM
    try {
      await scheduleCheckInReminder(
        id: 999,
        title: 'Monthly Check-in 🌙',
        body: "It's time to check in and let your loved ones know you're alright.",
        hour: 9,
        minute: 0,
      );
    } catch (e) {
      print("Error scheduling default check-in reminder: $e");
    }
  }

  /// Get device FCM token
  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (_) {
      return null;
    }
  }

  /// Show foreground local notification
  Future<void> _showLocalNotification(RemoteNotification notification) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails();
    const platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
    );
  }

  /// Schedule a timezone-aware local check-in reminder (e.g. daily reminder)
  Future<void> scheduleCheckInReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Cancel any existing reminder with this ID first
    await _localNotifications.cancel(id);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    // Schedule daily at the specified hour and minute
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at this time
    );
  }

  /// Cancel a scheduled check-in reminder
  Future<void> cancelCheckInReminder(int id) async {
    await _localNotifications.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _onNotificationTapped(NotificationResponse response) {
    print("Notification tapped with payload: ${response.payload}");
  }

  void _handleMessageTap(RemoteMessage message) {
    print("FCM notification tapped: ${message.notification?.title}");
  }
}
