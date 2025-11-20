import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/domain/repositories/i_todo_repository.dart';

class FetchTodosUseCase {
  final ITodoRepository _repository;

  FetchTodosUseCase(this._repository);
  //Memanggil Interface Repository untuk mendapatkan data real-time
  Future<List<Todo>> execute() async {
    return _repository.getTodos();
  }
}