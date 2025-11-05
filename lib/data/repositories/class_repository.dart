import 'package:luarsekolah/domain/repositories/i_class_repository.dart';
import 'package:luarsekolah/domain/entities/class_model.dart';
import 'package:luarsekolah/data/providers/api_service.dart';
import 'dart:io';

class ClassRepository implements IClassRepository {
  final ApiService _apiService;

  ClassRepository(this._apiService);

  @override
  Future<List<ClassModel>> getClasses(String category) async {
    await _apiService.initializeToken();
    final rawData = await _apiService.fetchCourses(category);
    return rawData.map((json) => ClassModel.fromJson(json)).toList();
  }

  @override
  Future<void> deleteClass(String id) {
    return _apiService.deleteCourse(id);
  }
  
  @override
  Future<void> editClass(String id, Map<String, dynamic> data) async {
    await _apiService.updateCourse(
      courseId: id,
      name: data['title'],
      price: data['price'],
      category: data['category'],
      thumbnailUrl: data['thumbnailUrl'],
    );
  }
  
  @override
  Future<void> updateClassStatus(String id, bool newStatus) async {
    return;
  }
  
  @override
  Future<void> addClassWithImage(Map<String, dynamic> data, File imageFile) async {
    await _apiService.createCourseWithImage(
      name: data['title'],
      price: data['price'],
      category: data['category'],
      imageFile: imageFile, 
    );
  }
  
  @override
  Future<void> addClassWithoutImage(Map<String, dynamic> data) async {
    await _apiService.createCourseWithoutImage(
      name: data['title'],
      price: data['price'],
      category: data['category'],
      thumbnailUrl: data['thumbnailUrl'],
    );
  }
}