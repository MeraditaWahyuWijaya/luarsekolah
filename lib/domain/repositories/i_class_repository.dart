import 'dart:io';
import '../entities/class_model.dart';

abstract class IClassRepository {
  Future<List<ClassModel>> getFilteredClasses(String category);
  Future<void> addClassWithImage(Map<String, dynamic> data, File imageFile);
  Future<void> addClassWithoutImage(Map<String, dynamic> data);
  Future<void> editClass(String id, Map<String, dynamic> data);
  Future<void> deleteClass(String id);
}
