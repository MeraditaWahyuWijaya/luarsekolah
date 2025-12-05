import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luarsekolah/domain/entities/todo.dart'; //model
import 'package:luarsekolah/data/providers/todo_firestore_service.dart';// kita import dulu api yg beneran 

// Mock service menggantikan TodoFirestoreService asli
// Tidak memanggil Firestore, hanya menyimpan data di memory
class MockTodoService implements TodoFirestoreService {
  final List<Todo> _store = []; //variabel ini buat database kita, kalo di firebase itu semacam collection
  
  @override
  CollectionReference get todosCollection => throw UnimplementedError();

  @override
  Future<List<Todo>> fetchTodos({bool? completedStatus}) async { //buat ambil dan filter data 
    if (completedStatus == null) return _store;
    return _store.where((t) => t.completed == completedStatus).toList();
  }

  @override
  Future<Todo> createTodo(String text) async { //nambahin item ke database
    final now = DateTime.now();
    final todo = Todo(
      id: now.millisecondsSinceEpoch.toString(),
      text: text,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );
    _store.add(todo);
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    _store.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> toggleTodo(String id, bool newStatus) async {
    final index = _store.indexWhere((t) => t.id == id);
    if (index != -1) {
      final old = _store[index];
      _store[index] = old.copyWith(
        completed: newStatus,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Stream<List<Todo>> streamTodos({bool? completedStatus}) async* {
    yield* Stream.periodic(const Duration(milliseconds: 10), (_) {
      if (completedStatus == null) return _store;
      return _store.where((t) => t.completed == completedStatus).toList();
    });
  }
}
