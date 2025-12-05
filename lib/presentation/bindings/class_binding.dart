import 'package:get/get.dart';
import '../../data/providers/api_service.dart';
import '../../data/repositories/class_repository.dart';
import '../controllers/class_controllers.dart';

class ClassBinding extends Bindings {
  @override
  void dependencies() {
    final api = ApiService();
    final repo = ClassRepository(api);
    Get.lazyPut(() => ClassController(repo));
  }
}
