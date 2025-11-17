import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/todo_firestore_service.dart';
import 'package:luarsekolah/presentation/controllers/todo_controllers.dart';

class TodoBinding implements Bindings {
  @override
  void dependencies() {
    // Daftarkan service Firestore
    Get.put(TodoFirestoreService());

    // Daftarkan controller
    Get.lazyPut<TodoController>(
      () => TodoController(Get.find<TodoFirestoreService>()),
    );
  }
}
