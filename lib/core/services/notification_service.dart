import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../firebase_options.dart';
import '../config/api_endpoints.dart';
import '../di/service_locator.dart';
import '../network/i_api_client.dart';
import '../router/app_router.dart';
import '../router/route_paths.dart';
import '../storage/token_storage.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class NotificationService {
  NotificationService._();

  static const String _channelId = 'general_notifications';
  static const String _channelName = 'General Notifications';

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    // 1. Initialize local notifications for foreground display
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null || response.payload!.isEmpty) return;
        try {
          final data = jsonDecode(response.payload!) as Map<String, dynamic>;
          _handleNavigation(data);
        } catch (_) {}
      },
    );

    // 2. Android notification channel & permissions
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          importance: Importance.high,
        ),
      );
      await androidPlugin.requestNotificationsPermission();
    }

    // 3. Request permissions from Firebase
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Foreground push banner
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null &&
          (Platform.isAndroid || message.notification == null)) {
        _showNotification(
          title: notification.title ?? 'Cheering',
          body: notification.body ?? '',
          payload: jsonEncode(message.data),
        );
      }
    });

    // 5. Notification tap handlers
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message.data);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }

    // 6. Token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen((_) => syncDeviceToken());

    _isInitialized = true;
  }

  static Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    final orderId = data['order_id'] ?? data['orderId'] ?? data['id'];
    final route = data['route'];

    void navigate() {
      if (orderId != null && orderId.toString().isNotEmpty) {
        AppRouter.router.push(RoutePaths.details(orderId.toString()));
      } else if (route != null && route.toString().isNotEmpty) {
        AppRouter.router.push(route.toString());
      }
    }

    if (WidgetsBinding.instance.isRootWidgetAttached) {
      navigate();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => navigate());
    }
  }

  /// Sync FCM token with backend: POST /api/v1/users/me/devices
  static Future<void> syncDeviceToken() async {
    if (TokenStorage.accessToken == null) return;

    try {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;

      final platform = Platform.isAndroid
          ? 'ANDROID'
          : (Platform.isIOS ? 'IOS' : 'WEB');

      await getIt<IApiClient>().post(
        ApiEndpoints.devices,
        body: {'fcm_token': token, 'platform': platform},
        fromJson: (_) {},
      );
    } catch (_) {}
  }

  /// Unregister FCM token on logout: DELETE /api/v1/users/me/devices/{fcm_token}
  static Future<void> removeDeviceToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;

      await getIt<IApiClient>().delete(
        ApiEndpoints.deleteDevice(token),
      );
    } catch (_) {}
  }
}
