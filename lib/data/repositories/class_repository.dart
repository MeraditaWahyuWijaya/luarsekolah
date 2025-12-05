import 'dart:io';
import '../../domain/entities/class_model.dart';
import '../providers/api_service.dart';

class ClassRepository {
  final ApiService api;

  ClassRepository(this.api);

  Future<List<ClassModel>> getFilteredClasses(String category) async {
    final data = await api.fetchCourses(category);
    return data.map((e) => ClassModel.fromMap(e, e['id'])).toList();
  }

  Future<void> addClassWithImage(Map<String, dynamic> data, File imageFile) async {
    await api.createCourseWithImage(data: data, imageFile: imageFile);
  }

  Future<void> addClassWithoutImage(Map<String, dynamic> data) async {
    await api.createCourseWithoutImage(data);
  }

  Future<void> editClass(String id, Map<String, dynamic> data) async {
    await api.updateCourse(id, data);
  }

  Future<void> deleteClass(String id) async {
    await api.deleteCourse(id);
  }
}
