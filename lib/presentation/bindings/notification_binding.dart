import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/notification_service.dart'; 
import 'package:luarsekolah/presentation/controllers/main_controller.dart'; 

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Daftarkan Service FCM sebagai permanent (Wajib)
    Get.put<NotificationService>(NotificationService(), permanent: true); 
    
    // 2. Daftarkan Controller
    Get.lazyPut<MainController>(() => MainController());
  }
}