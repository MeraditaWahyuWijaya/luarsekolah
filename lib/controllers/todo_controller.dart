import 'package:get/get.dart';
import 'package:luarsekolah/models/todo.dart';
import 'package:luarsekolah/services/todo_api_service.dart';
import 'package:flutter/material.dart';

enum TodoFilter { all, completed, pending }

class TodoController extends GetxController {
  final TodoApiService _apiService = TodoApiService();
  
  var todos = <Todo>[].obs; 
  var isLoading = false.obs;
  var errorMessage = Rxn<String>(); 
  var filter = TodoFilter.all.obs; 

  @override
  void onInit() {
    refreshTodos();
    super.onInit();
  }

  List<Todo> get filteredTodos {
    switch (filter.value) {
      case TodoFilter.completed:
        return todos.where((todo) => todo.completed).toList();
      case TodoFilter.pending:
        return todos.where((todo) => !todo.completed).toList();
      case TodoFilter.all:
      default:
        return todos.toList();
    }
  }
  
  int get completedCount => todos.where((todo) => todo.completed).length;
  double get completionRate => todos.isEmpty ? 0.0 : completedCount / todos.length;

  void setFilter(TodoFilter newFilter) {
    filter.value = newFilter;
  }

  Future<void> refreshTodos() async {
    isLoading(true);
    errorMessage(null);
    try {
      final fetchedTodos = await _apiService.fetchTodos();
      todos.assignAll(fetchedTodos);
    } catch (e) {
      errorMessage('Gagal memuat data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTodo(String text, String description) async {
    if (text.isEmpty) return;
    isLoading(true); 
    try {
      final newTodo = await _apiService.createTodo(text, description);
      todos.insert(0, newTodo); 
      Get.back();
      Get.snackbar(
        'Sukses',
        'Todo berhasil ditambahkan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal menambah Todo',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false); 
    }
  }

  Future<void> toggleTodo(String id) async {
    final todoIndex = todos.indexWhere((item) => item.id == id);
    if (todoIndex == -1) return;

    final oldTodo = todos[todoIndex];
    final oldCompleted = oldTodo.completed;
    todos[todoIndex] = oldTodo.copyWith(completed: !oldCompleted); 
    todos.refresh(); 

    try {
      await _apiService.toggleTodo(id); 
    } catch (e) {
      todos[todoIndex] = oldTodo.copyWith(completed: oldCompleted);
      todos.refresh();
      Get.snackbar(
        'Error Toggle',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteTodo(String id) async {
    final todoIndex = todos.indexWhere((item) => item.id == id);
    if (todoIndex == -1) return;
    
    final deletedTodo = todos.removeAt(todoIndex); 

    try {
      await _apiService.deleteTodo(id);
      Get.snackbar(
        'Dihapus',
        'Todo berhasil dihapus.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      todos.insert(todoIndex, deletedTodo); 
      todos.refresh();
      Get.snackbar(
        'Error Hapus',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }
}
