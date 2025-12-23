import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level function to handle background messages
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
  }
}

/// Service for handling Firebase Cloud Messaging (Push Notifications)
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _isInitialized = false;

  // Notification topics
  static const String topicAllUsers = 'all_users';
  static const String topicDailyChallenges = 'daily_challenges';
  static const String topicPromotions = 'promotions';
  static const String topicUpdates = 'updates';

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permission
      await requestPermission();

      // Get FCM token
      _fcmToken = await _messaging.getToken();

      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        if (kDebugMode) {
          print('FCM Token refreshed: $newToken');
        }
        // TODO: Update token in Firestore
      });

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup message handlers
      _setupMessageHandlers();

      _isInitialized = true;

      if (kDebugMode) {
        print('Notification service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Notification service initialization error: $e');
      }
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // TODO: Navigate to appropriate screen based on payload
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Foreground message received: ${message.notification?.title}');
      }
      _showNotification(message);
    });

    // Background messages (app open but in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Notification opened app: ${message.notification?.title}');
      }
      _handleNotificationTap(message);
    });

    // Check if app was opened from terminated state by notification
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          print('App opened from notification: ${message.notification?.title}');
        }
        _handleNotificationTap(message);
      }
    });
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (kDebugMode) {
        print('Notification permission granted: $granted');
      }

      return granted;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting notification permission: $e');
      }
      return false;
    }
  }

  /// Check notification permission status
  Future<bool> isPermissionGranted() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  /// Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'tokyo_roulette_channel',
      'Tokyo Roulette Notifications',
      channelDescription: 'Notifications for Tokyo Roulette Predicciones',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    
    if (kDebugMode) {
      print('Notification data: $data');
    }

    // TODO: Navigate based on notification type
    final type = data['type'] as String?;
    
    switch (type) {
      case 'prediction_reminder':
        // Navigate to prediction screen
        break;
      case 'win_notification':
        // Navigate to results screen
        break;
      case 'achievement':
        // Navigate to achievements screen
        break;
      case 'daily_challenge':
        // Navigate to daily challenges screen
        break;
      default:
        // Navigate to home screen
        break;
    }
  }

  // ==================== Topic Subscriptions ====================

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);

      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic $topic: $e');
      }
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);

      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic $topic: $e');
      }
    }
  }

  /// Subscribe to all users topic
  Future<void> subscribeToAllUsers() async {
    await subscribeToTopic(topicAllUsers);
  }

  /// Subscribe to daily challenges
  Future<void> subscribeToDailyChallenges() async {
    await subscribeToTopic(topicDailyChallenges);
  }

  /// Subscribe to promotions
  Future<void> subscribeToPromotions() async {
    await subscribeToTopic(topicPromotions);
  }

  /// Subscribe to updates
  Future<void> subscribeToUpdates() async {
    await subscribeToTopic(topicUpdates);
  }

  // ==================== Notification Types ====================

  /// Send welcome notification (local)
  Future<void> sendWelcomeNotification(String userName) async {
    const androidDetails = AndroidNotificationDetails(
      'tokyo_roulette_channel',
      'Tokyo Roulette Notifications',
      channelDescription: 'Notifications for Tokyo Roulette Predicciones',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      0,
      '¡Bienvenido, $userName!',
      'Comienza tu aventura en Tokyo Roulette Predicciones',
      details,
    );
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Delete FCM token (for sign out)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;

      if (kDebugMode) {
        print('FCM token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting FCM token: $e');
      }
    }
  }
}
