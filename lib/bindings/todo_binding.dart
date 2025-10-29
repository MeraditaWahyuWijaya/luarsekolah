import 'package:get/get.dart';
import '../controllers/todo_controller.dart'; 
import '../services/todo_api_service.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoApiService>(() => TodoApiService());
    Get.lazyPut<TodoController>(() => TodoController()); 
  }
}