import '../entities/class_model.dart';
import '../repositories/i_class_repository.dart';

class GetFilteredClassesUseCase {
  final IClassRepository repository;

  GetFilteredClassesUseCase(this.repository);

  Future<List<ClassModel>> execute(String category) async {
    return await repository.getFilteredClasses(category);
  }
}
