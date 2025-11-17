import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/domain/repositories/i_todo_repository.dart';
import 'package:luarsekolah/data/providers/todo_firestore_service.dart';

class TodoRepository implements ITodoRepository {
  final TodoFirestoreService _service;

  TodoRepository(this._service);

  @override
  Future<List<Todo>> getTodos() => _service.fetchTodos();

  @override
  Future<Todo> createTodo(String text) => _service.createTodo(text);

  @override
  Future<void> toggleTodo(String id, bool completed) =>
      _service.toggleTodo(id, completed);

  @override
  Future<void> deleteTodo(String id) => _service.deleteTodo(id);
}
