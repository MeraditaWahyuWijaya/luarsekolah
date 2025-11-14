import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/todo_api_service.dart';
import 'package:luarsekolah/data/repositories/todo_repository.dart';
import 'package:luarsekolah/domain/repositories/i_todo_repository.dart';
import 'package:luarsekolah/domain/usecases/fetch_todos_use_case.dart';
import 'package:luarsekolah/presentation/controllers/todo_controllers.dart';

class TodoBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<TodoApiService>(TodoApiService()); 

    Get.lazyPut<ITodoRepository>(
      () => TodoRepository(Get.find<TodoApiService>()),
    );

    Get.lazyPut<FetchTodosUseCase>(
      () => FetchTodosUseCase(Get.find<ITodoRepository>()),
    );

    Get.lazyPut<TodoController>(
      () => TodoController(
        Get.find<FetchTodosUseCase>(),
        Get.find<ITodoRepository>()
      ),
    );
  }
}