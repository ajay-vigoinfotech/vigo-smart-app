import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/widgets.dart';

class NotificationUtils {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Get FCM Device Token
  static Future<String> getDeviceToken() async {
    String? token = await _messaging.getToken();
    return token!;
  }

  // Listen for Token Refresh
  static void listenForTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      print('FCM Token Refreshed: $newToken');
    });
  }

  // Request Notification Permissions (especially for iOS)
  static Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Initialize Local Notifications
  static Future<void> initializeLocalNotifications(BuildContext context) async {
    var androidInitSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();

    var initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);

    await _localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (payload) {
          // Handle when a user clicks on a notification
          _handleMessage(context, payload as String?);
        });
  }

  // Show a Notification
  static Future<void> showLocalNotification(RemoteMessage message) async {
    var androidNotificationDetails = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var iosNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _localNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'No title',
      message.notification?.body ?? 'No body',
      notificationDetails,
    );
  }

  // Handle the Notification Click Event
  static void _handleMessage(BuildContext context, String? payload) {
    if (payload != null) {
      // Navigate or perform actions based on payload
      print('Notification payload: $payload');
    }
  }

  // Listen for FCM Messages in Foreground
  static void listenForMessages(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        showLocalNotification(message);
      }
    });
  }

  // Setup Notification Interactions (App Background/Terminated)
  static Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(context, initialMessage.data['type']);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(context, message.data['type']);
    });
  }
}
