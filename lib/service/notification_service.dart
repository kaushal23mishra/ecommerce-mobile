import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loggy/loggy.dart';
import 'package:salesdocket_core/salesdocket_core.dart';
import 'package:salesdocket_mobile/firebase_options.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static late AndroidNotificationChannel channel;

  static bool isInitialized = false;

  /// Background handler (runs in separate isolate)
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await _initializeLocalNotification();
    await _showFlutterNotification(message);
  }

  /// Main initializer (called in main.dart)
  static Future<void> initializeNotification(
    NotificationRepository repository,
  ) async {
    try {
      if (isInitialized) return;

      Loggy("NotificationService").info("Initializing...");

      await _createAndroidNotificationChannel();

      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await _initializeLocalNotification();
      await _setupFirebaseMessageHandlers();

      await _getFcmToken(repository);
      setupTokenRefreshListener(repository);

      // Handle terminated-state notification
      await _handleInitialMessage();

      isInitialized = true;
      Loggy("NotificationService").info("Notification service initialized");
    } catch (e, st) {
      Loggy(
        "NotificationService",
      ).error("Failed to initialize notification service: $e", e, st);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // HANDLERS
  // ─────────────────────────────────────────────────────────────

  static Future<void> _setupFirebaseMessageHandlers() async {
    /// Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Loggy(
        "NotificationService",
      ).info("Foreground message received: ${message.messageId}");

      await _showLocalNotificationForFirebaseMessage(message);
    });

    /// Background (but app is resumed)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Loggy(
        "NotificationService",
      ).info("Message opened from background: ${message.messageId}");

      _handleNotificationData(message.data);
    });
  }

  /// Terminated state
  static Future<void> _handleInitialMessage() async {
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Loggy(
        "NotificationService",
      ).info("App opened from terminated state: ${message.data}");

      // ❗ NO local notification here — user already tapped push
      _handleNotificationData(message.data);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SHOW NOTIFICATIONS
  // ─────────────────────────────────────────────────────────────

  static Future<void> _showLocalNotificationForFirebaseMessage(
    RemoteMessage message,
  ) async {
    try {
      final title =
          message.notification?.title ?? message.data['title'] ?? 'Salesdocket';
      final body =
          message.notification?.body ??
          message.data['body'] ??
          'You have a new notification';

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: '@mipmap/ic_launcher',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        autoCancel: true,
        styleInformation: BigTextStyleInformation(body),
      );

      final iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iOSDetails),

        /// FIXED: Always encode properly
        payload: jsonEncode(message.data),
      );
    } catch (e, st) {
      Loggy(
        "NotificationService",
      ).error("Failed to show local notification: $e", e, st);
    }
  }

  /// Background isolate uses this
  static Future<void> _showFlutterNotification(RemoteMessage message) async {
    try {
      final title =
          message.notification?.title ?? message.data['title'] ?? 'Salesdocket';
      final body =
          message.notification?.body ??
          message.data['body'] ??
          'You have a new notification';

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        autoCancel: true,
      );

      final iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iOSDetails),

        /// FIXED: proper JSON payload
        payload: jsonEncode(message.data),
      );
    } catch (e, st) {
      Loggy(
        "NotificationService",
      ).error("Failed to show flutter notification: $e", e, st);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // PAYLOAD HANDLER
  // ─────────────────────────────────────────────────────────────

  static Function(Map<String, dynamic>)? onNavigate;

  static void _handleNotificationData(Map<String, dynamic> data) {
    try {
      Loggy("NotificationService").info("Handling payload → $data");
      if (onNavigate != null) onNavigate!(data);
    } catch (e) {
      Loggy(
        "NotificationService",
      ).error("Failed to handle notification navigation: $e");
    }
  }

  // ─────────────────────────────────────────────────────────────
  // INIT / TOKEN / CHANNEL
  // ─────────────────────────────────────────────────────────────

  static Future<void> _initializeLocalNotification() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          try {
            final data = json.decode(payload) as Map<String, dynamic>; // FIXED
            _handleNotificationData(data);
          } catch (e) {
            Loggy(
              "NotificationService",
            ).error("Invalid payload received: $payload");
          }
        }
      },
    );
  }

  static Future<void> _createAndroidNotificationChannel() async {
    channel = const AndroidNotificationChannel(
      pushNotificationChannelId,
      pushNotificationChannelName,
      description: 'Salesdocket push notifications',
      importance: Importance.max,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    );

    final androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(channel);
  }

  // ─────────────────────────────────────────────────────────────
  // TOKEN MGMT
  // ─────────────────────────────────────────────────────────────

  static Future<void> _getFcmToken(NotificationRepository repository) async {
    final token = await _firebaseMessaging.getToken();
    Loggy("NotificationService").info("FCM Token: $token");
  }

  static void setupTokenRefreshListener(NotificationRepository repository) {
    _firebaseMessaging.onTokenRefresh.listen((token) {
      Loggy("NotificationService").info("FCM Token refreshed: $token");
    });
  }
}
