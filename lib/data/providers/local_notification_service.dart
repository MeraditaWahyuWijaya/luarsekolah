import 'package:luarsekolah/presentation/controllers/main_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/controllers/main_controller.dart'; 

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    await _notifications.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (response) {
        final todoId = response.payload;
        if (todoId != null) {
          // Panggil Controller untuk navigasi Deep Link
          Get.find<MainController>().handleNotificationClick(todoId);
        }
      },
    );
    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'todo_updates_channel', 
      'Pembaruan To-Do', 
      importance: Importance.max,
      description: 'Notifikasi untuk perubahan status dan data To-Do',
    );
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Dipanggil oleh FCM Service untuk menampilkan notif di FOREGROUND
  static Future<void> show({
    required String title,
    required String body,
    String? payload, // Akan berisi todoId
  }) async {
    await _notifications.show(
      title.hashCode, 
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_updates_channel',
          'Pembaruan To-Do',
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: payload,
    );
  }

  // Dipanggil untuk PENJADWALAN OFFLINE (Pengingat Batas Waktu)
  static Future<void> schedule({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await _notifications.zonedSchedule(
      title.hashCode,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('todo_updates_channel', 'Pembaruan To-Do'),
      ),
      payload: payload,
   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}