import 'package:luarsekolah/domain/repositories/i_todo_repository.dart';
import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/data/providers/todo_api_service.dart';

class TodoRepository implements ITodoRepository {
  final TodoApiService _apiService;

 TodoRepository(this._apiService);

  @override
  Future<List<Todo>> getTodos() async {
     return await _apiService.fetchTodos();
  }

  @override
  Future<Todo> createTodo(String title, String description) {
    return _apiService.createTodo(title, description);
  }

  @override
  Future<void> toggleTodo(String id) {
    return _apiService.toggleTodo(id);
  }

  @override
  Future<void> deleteTodo(String id) {
    return _apiService.deleteTodo(id);
  }
}