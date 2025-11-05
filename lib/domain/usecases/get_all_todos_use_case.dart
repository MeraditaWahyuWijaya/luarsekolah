import 'package:luarsekolah/domain/entities/todo.dart';
import 'package:luarsekolah/domain/repositories/i_todo_repository.dart';

class GetAllTodosUseCase {
  final ITodoRepository _repository;

  GetAllTodosUseCase(this._repository);

  Future<List<Todo>> execute() async {
    return _repository.getTodos(); // Asumsi Anda punya method getTodos()
  }
}