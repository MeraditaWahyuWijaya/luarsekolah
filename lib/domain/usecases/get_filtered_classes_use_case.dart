import 'package:luarsekolah/domain/entities/class_model.dart';
import 'package:luarsekolah/domain/repositories/i_class_repository.dart';

class GetFilteredClassesUseCase {
  final IClassRepository _repository;

  GetFilteredClassesUseCase(this._repository);

  Future<List<ClassModel>> execute(String selectedCategory) async {
    final List<ClassModel> allClasses = await _repository.getClasses(selectedCategory);

    final selectedCategoryDisplay = selectedCategory.toLowerCase(); 

    return allClasses.where((kelas) {
      final categoryTag = kelas.category.toLowerCase();
      
      if (selectedCategoryDisplay.contains('populer')) {
        return categoryTag.contains('populer') || 
               categoryTag.contains('umum') || 
               categoryTag.contains('prakerja');
      } else if (selectedCategoryDisplay.contains('spl')) {
        return categoryTag.contains('spl') || 
               categoryTag.contains('spesial');
      }
      
      return true; 
    }).toList();
  }
}