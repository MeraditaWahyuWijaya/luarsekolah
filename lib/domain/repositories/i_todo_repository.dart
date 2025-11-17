// Interface repository, mendefinisikan contract untuk Todo
import 'package:luarsekolah/domain/entities/todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getTodos();                     // Mendapatkan semua todo
  Future<Todo> createTodo(String text);             // Membuat todo baru
  Future<void> toggleTodo(String id, bool completed); // Toggle status todo
  Future<void> deleteTodo(String id);              // Menghapus todo
}
