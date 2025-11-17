import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luarsekolah/domain/entities/todo.dart';

class TodoFirestoreService {
  // Inisialisasi Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getter untuk collection 'todos'
  CollectionReference get todosCollection => _firestore.collection('todos');

  // Fetch semua todo secara sekali jalan (Future)
  Future<List<Todo>> fetchTodos() async {
    try {
      final snapshot = await todosCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Todo(
          id: doc.id,
          text: data['text'] as String,
          completed: data['completed'] as bool,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Gagal memuat todo: $e');
    }
  }

  // Stream untuk mendengarkan perubahan realtime
  Stream<List<Todo>> streamTodos() {
    return todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Todo(
          id: doc.id,
          text: data['text'] as String,
          completed: data['completed'] as bool,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          updatedAt: (data['updatedAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Tambah todo baru
  Future<Todo> createTodo(String text) async {
    try {
      final now = DateTime.now();
      final docRef = await todosCollection.add({
        'text': text,
        'completed': false,
        'createdAt': now,
        'updatedAt': now,
      });
      return Todo(
        id: docRef.id,
        text: text,
        completed: false,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e) {
      throw Exception('Gagal menambah todo: $e');
    }
  }

  // Toggle status todo
  Future<void> toggleTodo(String id, bool completed) async {
    try {
      await todosCollection.doc(id).update({
        'completed': completed,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Gagal toggle todo: $e');
    }
  }

  // Hapus todo
  Future<void> deleteTodo(String id) async {
    try {
      await todosCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus todo: $e');
    }
  }
}
