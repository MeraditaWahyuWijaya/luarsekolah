import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/controllers/main_controller.dart';
import 'package:luarsekolah/data/providers/local_notification_service.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif = FlutterLocalNotificationsPlugin();

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

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotif.initialize(
      const InitializationSettings(android: androidSettings),
    );

    String? token = await getFCMToken();
    print('FCM Token: $token');

    await _handleInitialMessage();
  }

  void startFCMListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;

      if (notification != null) {
        LocalNotificationService.show(
          title: notification.title ?? 'Pembaruan',
          body: notification.body ?? 'Ada perubahan data.',
          payload: data['todoId'],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final todoId = message.data['todoId'];
      if (todoId != null) {
        Get.find<MainController>().handleNotificationClick(todoId);
      }
    });
  }

  Future<String?> getFCMToken() async {
    return await _fcm.getToken();
  }

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

  Future<void> sendTopicNotification({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    const serverKey = "<SERVER_KEY_FIREBASE>"; 
    final url = Uri.parse("https://fcm.googleapis.com/fcm/send");

    final payload = {
      "to": "/topics/$topic",
      "notification": {"title": title, "body": body},
      "data": data ?? {},
    };

    final response = await HttpClient().postUrl(url).then((req) {
      req.headers.set('Content-Type', 'application/json');
      req.headers.set('Authorization', 'key=$serverKey');
      req.add(utf8.encode(json.encode(payload)));
      return req.close();
    });

    if (response.statusCode == 200) {
      print("Notifikasi topic $topic berhasil dikirim");
    } else {
      print("Gagal mengirim notifikasi: ${response.statusCode}");
    }
  }
}
