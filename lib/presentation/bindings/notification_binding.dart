import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/notification_service.dart';
import 'package:luarsekolah/presentation/controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Daftarkan NotificationService sebagai permanent
    Get.put<NotificationService>(NotificationService(), permanent: true);

    // Daftarkan MainController
    Get.lazyPut<MainController>(() => MainController());
  }
}
