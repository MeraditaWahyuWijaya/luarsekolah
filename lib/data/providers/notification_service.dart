import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/controllers/main_controller.dart';
import 'package:luarsekolah/data/providers/local_notification_service.dart'; // Akses Local Notif Service

class NotificationService {
  final _fcm = FirebaseMessaging.instance;
  final _localNotif = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _fcm.requestPermission();
    
    // Inisialisasi basic Local Notif (hanya untuk setting awal)
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotif.initialize(
        const InitializationSettings(android: initializationSettingsAndroid));
    
    // Handler notif saat app dibuka dari Terminated state
    await _handleInitialMessage(); 
  }

  void startFCMListener() {
    // 1. HANDLER FOREGROUND (FCM memicu Local Notif)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data; 

      if (notification != null) {
        // Panggil LocalNotificationService (static) untuk tampilan visual
        LocalNotificationService.show(
          title: notification.title ?? 'Pembaruan To-Do',
          body: notification.body ?? 'Ada perubahan data.',
          payload: data['todoId'], // ID To-Do untuk navigasi
        );
      }
    });

    // 2. HANDLER BACKGROUND (FCM Deep Link)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final todoId = message.data['todoId']; 
      if (todoId != null) {
        // Panggil Controller untuk navigasi
        Get.find<MainController>().handleNotificationClick(todoId);
      }
    });
  }

  Future<void> _handleInitialMessage() async {
    RemoteMessage? message = await _fcm.getInitialMessage();
    if (message != null) {
      final todoId = message.data['todoId'];
      if (todoId != null) {
        // Beri jeda agar GetX siap sebelum navigasi
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.find<MainController>().handleNotificationClick(todoId);
        });
      }
    }
  }

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }
}