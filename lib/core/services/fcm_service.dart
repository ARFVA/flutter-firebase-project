import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level background message handler.
/// Must be annotated with @pragma('vm:entry-point') and registered via
/// [FirebaseMessaging.onBackgroundMessage] before runApp.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background FCM message: ${message.messageId}');
}

/// Service that encapsulates all Firebase Cloud Messaging concerns:
/// permission, foreground display, background handler, token lifecycle, topics.
class FCMService {
  FCMService._();
  static final FCMService instance = FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Important StudyQuest notifications',
    importance: Importance.high,
  );

  bool _initialized = false;

  Future<void> initialize() async {
    if (kIsWeb || _initialized) return;

    // Register background handler once.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Android notification channel + local notifications for foreground display.
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Permission (iOS + Android 13+).
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Foreground messages: display via local notification.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // Notification tapped while app in background.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Notification opened: ${message.messageId}');
    });

    // Initial message when app launched from terminated state.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched from notification: ${initialMessage.messageId}');
    }

    // Subscribe to broadcast topic.
    await _messaging.subscribeToTopic('all');

    // Token rotation: keep stored token fresh.
    _messaging.onTokenRefresh.listen((token) {
      debugPrint('FCM token refreshed');
    });

    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
    _initialized = true;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'StudyQuest',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['route'],
    );
  }

  Future<String?> getToken() => _messaging.getToken();

  /// Persists the current FCM token onto the user's Firestore profile so the
  /// backend can target this device with pushes (e.g. streak reminders).
  Future<void> saveTokenToProfile(String uid) async {
    if (kIsWeb) return;
    try {
      final token = await _messaging.getToken();
      if (token == null) return;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
      debugPrint('FCM token saved for user $uid');
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  Future<void> subscribeToUserTopic(String uid) =>
      _messaging.subscribeToTopic('user_$uid');

  Future<void> unsubscribeFromUserTopic(String uid) =>
      _messaging.unsubscribeFromTopic('user_$uid');
}
