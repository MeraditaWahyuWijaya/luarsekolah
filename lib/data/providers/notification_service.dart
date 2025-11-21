import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/controllers/main_controller.dart';
import 'package:luarsekolah/data/providers/local_notification_service.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif = FlutterLocalNotificationsPlugin();

  /// Inisialisasi permission FCM dan Local Notification
  Future<void> initialize() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }

    // Setup Local Notification Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotif.initialize(
      const InitializationSettings(android: androidSettings),
    );

    // Ambil FCM token dan tampilkan di console
    String? token = await getFCMToken();
    print('FCM Token: $token');

    // Cek jika app dibuka dari terminated state lewat notif
    await _handleInitialMessage();
  }

  /// Mulai listener FCM
  void startFCMListener() {
    // Handler untuk pesan masuk saat app foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;

      if (notification != null) {
        LocalNotificationService.show(
          title: notification.title ?? 'Pembaruan To-Do',
          body: notification.body ?? 'Ada perubahan data.',
          payload: data['todoId'],
        );
      }
    });

    // Handler saat user tap notifikasi (background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final todoId = message.data['todoId'];
      if (todoId != null) {
        Get.find<MainController>().handleNotificationClick(todoId);
      }
    });
  }

  /// Ambil FCM token
  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }

  /// Handler untuk app dibuka dari terminated state via notification
  Future<void> _handleInitialMessage() async {
    RemoteMessage? message = await _fcm.getInitialMessage();
    if (message != null) {
      final todoId = message.data['todoId'];
      if (todoId != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.find<MainController>().handleNotificationClick(todoId);
        });
      }
    }
  }
}
