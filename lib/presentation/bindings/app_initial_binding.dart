import 'package:get/get.dart';
import '../controllers/auth_check_controller.dart';

class AppInitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthCheckController>(AuthCheckController(), permanent: true);
  }
}