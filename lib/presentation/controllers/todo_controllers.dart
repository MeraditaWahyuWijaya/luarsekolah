import 'package:get/get.dart';
import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/data/providers/todo_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:luarsekolah/data/providers/local_notification_service.dart';

// Enum untuk filter todo di UI
enum TodoFilter { all, completed, pending }

class TodoController extends GetxController {
  final TodoFirestoreService _firestoreService;

  // Mode test untuk unit test, agar tidak memanggil Firestore dan notifikasi
  final bool isTest;

  // List todo observable agar UI otomatis refresh saat berubah
  var todos = <Todo>[].obs;

  // Status loading dan error
  var isLoading = false.obs;
  var errorMessage = Rxn<String>();

  // Filter todo
  var filter = TodoFilter.all.obs;

  // Stream listener dari Firestore
  Stream<List<Todo>>? _todoStream;
  late Rx<Stream<List<Todo>>> _streamObs;

  // Constructor menerima service dan flag isTest default false
  TodoController(this._firestoreService, {this.isTest = false});

  @override
  void onInit() {
    super.onInit();

    // Hanya jalankan stream Firestore jika bukan mode test
    if (!isTest) {
      _todoStream = _firestoreService.streamTodos();
      _streamObs = _todoStream!.obs;
      // Listen stream setiap update
      ever(_streamObs, (_) => _listenTodos());
      _listenTodos();
    }
  }

  // Mendengarkan perubahan todo dari Firestore
  void _listenTodos() {
    isLoading(true);
    try {
      _todoStream?.listen((list) {
        todos.assignAll(list); // update list observable
        isLoading(false);
      });
    } catch (e) {
      errorMessage('Gagal memuat data: $e');
      isLoading(false);
    }
  }

  // Filtered list untuk UI
  List<Todo> get filteredTodos {
    switch (filter.value) {
      case TodoFilter.completed:
        return todos.where((t) => t.completed).toList();
      case TodoFilter.pending:
        return todos.where((t) => !t.completed).toList();
      case TodoFilter.all:
      default:
        return todos.toList();
    }
  }

  int get completedCount => todos.where((t) => t.completed).length;
  double get completionRate => todos.isEmpty ? 0.0 : completedCount / todos.length;

  // Set filter
  void setFilter(TodoFilter newFilter) {
    filter.value = newFilter;
  }

  // Tambah todo baru
Future<void> addTodo(String text) async {
  if (text.isEmpty) return;

  try {
    final newTodo = await _firestoreService.createTodo(text);

    todos.add(newTodo);

    // Snackbar
    Get.snackbar(
      'Sukses',
      'Todo berhasil ditambahkan!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade400,
      colorText: Colors.white,
    );

    // Local Notification
    LocalNotificationService.show(
      title: 'Catatan Baru',
      body: text,
      payload: newTodo.id,
    );
  } catch (e) {
    Get.snackbar(
      'Gagal menambah Todo',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
    );
  }
}


  // Toggle status todo (selesai / belum)
  Future<void> toggleTodo(String id) async {
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) return;

    final oldTodo = todos[todoIndex];
    final newStatus = !oldTodo.completed;

    // Update UI langsung
    todos[todoIndex] = oldTodo.copyWith(completed: newStatus);
    todos.refresh();

    if (!isTest) {
      try {
        // Kirim ke Firestore dengan status baru
        await _firestoreService.toggleTodo(id, newStatus);
      } catch (e) {
        // rollback jika toggle gagal
        todos[todoIndex] = oldTodo;
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
  }

  // Hapus todo
  Future<void> deleteTodo(String id) async {
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) return;

    final deletedTodo = todos.removeAt(todoIndex);
    todos.refresh();

    if (!isTest) {
      try {
        await _firestoreService.deleteTodo(id);
        Get.snackbar(
          'Dihapus',
          'Todo berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade400,
          colorText: Colors.white,
        );
      } catch (e) {
        // rollback jika delete gagal
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

  // Refresh manual (opsional, untuk tombol refresh)
  Future<void> refreshTodos() async {
    isLoading(true);
    try {
      final list = await _firestoreService.fetchTodos();
      todos.assignAll(list);
    } catch (e) {
      errorMessage('Gagal refresh: $e');
    } finally {
      isLoading(false);
    }
  }
}
