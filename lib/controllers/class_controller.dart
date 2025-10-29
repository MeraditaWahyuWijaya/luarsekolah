import 'package:get/get.dart';
import '../models/class_model.dart';
import '../services/api_service.dart'; 
import 'package:flutter/material.dart';

enum ClassOption { edit, delete } 
enum ClassCategory { populer, spl } 

class ClassController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var allClasses = <ClassModel>[].obs; 
  var isLoading = true.obs; 
  var errorMessage = ''.obs; 
  
  var selectedCategory = ClassCategory.populer.obs; 
  var isFormVisible = false.obs; 
  var isEditMode = false.obs; 
  
  ClassModel? classToEdit; 

  @override
  void onInit() {
    super.onInit();
    fetchClasses(); 
  }

  Future<void> fetchClasses() async {
    isLoading(true);
    errorMessage('');
    try {
      await _apiService.initializeToken();
      final List<Map<String, dynamic>> data = await _apiService.fetchCourses();
      
      allClasses.value = data.map((json) => ClassModel.fromJson(json)).toList();

    } catch (e) {
      errorMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }

  List<ClassModel> get filteredClasses {
    return allClasses.where((kelas) {
      final categoryTag = kelas.category.toLowerCase();
      
      if (selectedCategory.value == ClassCategory.populer) {
        return categoryTag.contains('populer') || categoryTag.contains('umum');
      } else {
        return categoryTag.contains('spl') || categoryTag.contains('spesial');
      }
    }).toList();
  }

  void selectCategory(ClassCategory category) {
    selectedCategory.value = category; 
  }
  
  void showAddForm() {
    isEditMode(false);
    classToEdit = null;
    isFormVisible(true);
  }

  void showEditForm(ClassModel classData) {
    isEditMode(true);
    classToEdit = classData;
    isFormVisible(true);
  }

  void hideForm() {
    isFormVisible(false);
    isEditMode(false);
    classToEdit = null;
  }
  
  Future<void> submitAddClass(Map<String, dynamic> formData) async {
    print('Mengirim data form ke API: $formData'); 

    try {
      final String thumbnailUrl = 'https://picsum.photos/300/200?random=${DateTime.now().millisecondsSinceEpoch}';

      await _apiService.createCourse(
        name: formData['title'],
        price: formData['price'],
        category: formData['category'].toString().split('.').last,
        thumbnailUrl: thumbnailUrl,
      );

      await fetchClasses(); 
      hideForm();

      Get.snackbar(
        'Berhasil', 
        'Kelas "${formData['title']}" berhasil ditambahkan!', 
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      String errorMessage;
      print('API Create Course GAGAL: $e'); 

      if (e is Exception || e is Error){
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else {
        errorMessage = 'Kesalahan tidak terduga saat koneksi: $e';
      }
      
      Get.snackbar(
        'Gagal', 
        'Gagal menambah kelas: $errorMessage', 
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteClass(String classId, String classTitle) async {
    try {
      await _apiService.deleteCourse(classId);
      
      allClasses.removeWhere((kelas) => kelas.id == classId); 
      
      Get.snackbar(
        'Berhasil', 
        'Kelas "$classTitle" berhasil dihapus!', 
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal', 
        'Gagal menghapus kelas: ${e.toString().replaceFirst('Exception: ', '')}', 
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleCompletionStatus(ClassModel classItem) {
    final index = allClasses.indexWhere((k) => k.id == classItem.id);
    
    if (index != -1) {
        classItem.isCompleted = !classItem.isCompleted;
        allClasses[index] = classItem; 
    }
  }
  
  Future<void> submitEditClass(Map<String, dynamic> formData) async {
    if (classToEdit == null) return;
    
    final String idToEdit = classToEdit!.id;
    final String oldThumbnail = classToEdit!.thumbnailUrl;

    try {
      await _apiService.updateCourse(
        courseId: idToEdit,
        name: formData['title'],
        price: formData['price'],
        category: formData['category'].toString().split('.').last,
        thumbnailUrl: oldThumbnail,
      );

      await fetchClasses(); 
      hideForm();
      Get.snackbar(
        'Berhasil', 
        'Kelas "${formData['title']}" berhasil diedit!', 
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal', 
        'Gagal mengedit kelas: ${e.toString().replaceFirst('Exception: ', '')}', 
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}