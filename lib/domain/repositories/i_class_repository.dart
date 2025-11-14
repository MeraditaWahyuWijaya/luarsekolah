import 'package:luarsekolah/domain/entities/class_model.dart';
import 'dart:io';

abstract class IClassRepository {
  
  Future<List<ClassModel>> getClasses(String category);
  Future<void> deleteClass(String classId);
  Future<void> updateClassStatus(String classId, bool isCompleted);
  Future<void> editClass(String classId, Map<String, dynamic> data);
  
  Future<void> addClassWithImage(Map<String, dynamic> data, File imageFile);
  Future<void> addClassWithoutImage(Map<String, dynamic> data);
}