import 'package:flutter_test/flutter_test.dart';
import 'package:luarsekolah/presentation/controllers/todo_controllers.dart';
import 'package:luarsekolah/domain/entities/todo.dart';
import 'mock/mock_todo_service.dart';

void main() {
  late TodoController controller;
  late MockTodoService mockService;

  setUp(() {
    // Gunakan mock service dan aktifkan mode test supaya tidak memanggil Firestore atau notifikasi
    mockService = MockTodoService();
    controller = TodoController(mockService, isTest: true);
  });

  test('Menambahkan todo harus menambah jumlah daftar', () async {
    // Pastikan list kosong awalnya
    expect(controller.todos.length, 0);

    // Tambah todo
    await controller.addTodo('Belajar Flutter');

    // Cek list bertambah
    expect(controller.todos.length, 1);
    expect(controller.todos[0].text, 'Belajar Flutter');
    expect(controller.todos[0].completed, false);
  });

  test('Toggle todo harus mengubah status completed', () async {
    await controller.addTodo('Testing');
    final todo = controller.todos.first;

    final before = todo.completed;

    await controller.toggleTodo(todo.id);

    expect(controller.todos.first.completed, !before);
  });

  test('Menghapus todo harus mengurangi daftar', () async {
    await controller.addTodo('Testing Hapus');
    final todo = controller.todos.first;

    await controller.deleteTodo(todo.id);

    expect(controller.todos.length, 0);
  });

  test('completedCount dan completionRate menghitung dengan benar', () async {
    await controller.addTodo('Todo 1');
    await controller.addTodo('Todo 2');

    final todo1 = controller.todos[0];
    final todo2 = controller.todos[1];

    // Tandai satu todo selesai
    await controller.toggleTodo(todo1.id);

    expect(controller.completedCount, 1);
    expect(controller.completionRate, 0.5);
  });
}
