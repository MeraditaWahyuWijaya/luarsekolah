import 'package:luarsekolah/domain/entities/todo.dart';
import 'dart:io';

abstract class ITodoRepository {
  Future<List<Todo>> getTodos();
  Future<Todo> createTodo(String title, String description);
  Future<void> toggleTodo(String id);
  Future<void> deleteTodo(String id);

}