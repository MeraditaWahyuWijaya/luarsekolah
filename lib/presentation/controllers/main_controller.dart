import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/notification_service.dart'; // Service FCM
import 'package:luarsekolah/data/providers/local_notification_service.dart'; // Service Local Notif

class MainController extends GetxController {
  final NotificationService _notifService = Get.find<NotificationService>(); 
  RxString fcmToken = 'Memuat Token...'.obs;

  @override
  void onInit() {
    super.onInit();
    _setupNotifications();
  }

  void _setupNotifications() async {
    // 1. Inisialisasi Service Local Notif (wajib sebelum FCM listener)
    await LocalNotificationService.initialize();
    
    // 2. Inisialisasi dan Start Listener FCM
    await _notifService.initialize();
    _notifService.startFCMListener();
    
    _fetchAndSendToken();
  }
  
  // Contoh fungsi untuk menjadwalkan notif offline (misal 1 jam dari sekarang)
  void scheduleTestReminder() {
      DateTime scheduledTime = DateTime.now().add(Duration(hours: 1));
      LocalNotificationService.schedule(
          title: 'Pengingat Otomatis',
          body: 'Ini adalah pengingat yang dijadwalkan secara offline.',
          scheduledTime: scheduledTime,
          payload: 'todo_offline_123',
      );
  }


  void _fetchAndSendToken() async {
    final token = await _notifService.getFCMToken();
    if (token != null) {
      fcmToken.value = 'Token Sukses: ${token.substring(0, 15)}...'; 
    }
  }

  // 🚨 FUNGSI INTI: PUSAT NAVIGASI DEEP LINK
  void handleNotificationClick(String todoId) {
    print('Navigasi dipicu untuk To-Do ID: $todoId');
    
    Get.toNamed(
      '/todo_detail', 
      parameters: {'id': todoId}
    );
  }
}