import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/notification_service.dart';
import 'package:luarsekolah/data/providers/local_notification_service.dart';

class MainController extends GetxController {
  final NotificationService _notifService = Get.find<NotificationService>();
  RxString fcmToken = 'Memuat Token...'.obs;

  @override
  void onInit() {
    super.onInit();
    _setupNotifications();
  }

  /// Inisialisasi Local Notification + FCM + start listener
  void _setupNotifications() async {
    await LocalNotificationService.initialize(); // wajib sebelum FCM listener
    await _notifService.initialize();
    _notifService.startFCMListener();
    _fetchToken();
  }

  /// Ambil FCM token dan update observable
  void _fetchToken() async {
    final token = await _notifService.getFCMToken();
    if (token != null) {
      fcmToken.value = 'Token: ${token.substring(0, 15)}...';
      print(fcmToken.value); // tampilkan token di console
    }
  }

  /// Navigasi ketika user klik notifikasi
  void handleNotificationClick(String todoId) {
    print('Navigasi dipicu untuk To-Do ID: $todoId');
    Get.toNamed('/todo_detail', parameters: {'id': todoId});
  }

  // NOTE: Fungsi scheduleTestReminder dihapus karena kita hanya pakai notifikasi instan
}
