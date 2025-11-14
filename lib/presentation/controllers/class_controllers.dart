import 'package:get/get.dart';
import 'package:luarsekolah/domain/entities/class_model.dart';
import 'package:luarsekolah/domain/usecases/get_filtered_classes_use_case.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; 
import 'package:luarsekolah/domain/repositories/i_class_repository.dart';

enum ClassOption { edit, delete } 
enum ClassCategory { populer, spl } 

class ClassController extends GetxController {
  final GetFilteredClassesUseCase _fetchClassesUseCase; 
  final IClassRepository _repository;

  ClassController(this._fetchClassesUseCase, this._repository); 
  
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
      final String categoryString = selectedCategory.value.name;
      
      final List<ClassModel> data = await _fetchClassesUseCase.execute(categoryString);
      allClasses.assignAll(data);
      update();
    } catch (e) {
      errorMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading(false);
    }
  }

  List<ClassModel> get filteredClasses => allClasses.value;

  void selectCategory(ClassCategory category) {
    selectedCategory.value = category;
    fetchClasses();
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
    isLoading(true);
    
    final imagePickerResult = formData['imageAsset'];
    final thumbnailUrl = formData['thumbnailUrl']; 
    File? imageFile;

    if (imagePickerResult != null && imagePickerResult is List && imagePickerResult.isNotEmpty) {
      final firstItem = imagePickerResult.first;

      if (firstItem is File) {
        imageFile = firstItem;
      } else if (firstItem.runtimeType.toString() == 'XFile') {
        try {
          final xFile = firstItem as XFile;
          imageFile = File(xFile.path);
        } catch (e) {
          debugPrint('Error casting to XFile: $e');
        }
      }
    }
    
    final String title = formData['title'];
    final Map<String, dynamic> dataToSend = {
      'title': title,
      'price': formData['price'],
      'category': formData['category'].toString().split('.').last,
    };
    
    try {
        if (imageFile != null) {
            await _repository.addClassWithImage(dataToSend, imageFile); 
        } else if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
            dataToSend['thumbnailUrl'] = thumbnailUrl;
            await _repository.addClassWithoutImage(dataToSend);
        } else {
            isLoading(false);
            Get.snackbar('Perhatian', 'Harap pilih gambar atau masukkan URL Thumbnail.', 
                backgroundColor: Colors.orange.shade600, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM,
            );
            return;
        }

        await fetchClasses(); 
        hideForm();
        Get.snackbar(
            'Berhasil', 
            'Kelas "$title" berhasil ditambahkan!', 
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
        );
        
    } catch (e) {
        Get.snackbar(
            'Gagal', 
            'Gagal menambah kelas: ${e.toString().replaceFirst('Exception: ', '')}', 
            backgroundColor: Colors.red.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
        );
        
    } finally {
        isLoading(false);
    }
  }

  Future<void> deleteClass(String classId, String classTitle) async {
    try {
      allClasses.removeWhere((kelas) => kelas.id == classId);
      allClasses.refresh();
      await _repository.deleteClass(classId);
      
      Get.snackbar(
        'Berhasil', 
        'Kelas "$classTitle" berhasil dihapus!', 
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      fetchClasses(); 
      Get.snackbar(
        'Gagal', 
        'Gagal menghapus kelas: ${e.toString().replaceFirst('Exception: ', '')}', 
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleCompletionStatus(ClassModel classItem) async {
    final index = allClasses.indexWhere((k) => k.id == classItem.id);
    if (index == -1) return;

    final oldStatus = classItem.isCompleted;
    allClasses[index] = classItem.copyWith(isCompleted: !oldStatus); 
    allClasses.refresh();
    
    try {
      await _repository.updateClassStatus(classItem.id, !oldStatus);
    } catch (e) {
      allClasses[index] = classItem.copyWith(isCompleted: oldStatus); 
      allClasses.refresh();
      Get.snackbar('Gagal', 'Gagal mengubah status: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }
  
  Future<void> submitEditClass(Map<String, dynamic> formData) async {
    if (classToEdit == null) return;
    
    final String idToEdit = classToEdit!.id;
    final String oldThumbnail = classToEdit!.thumbnailUrl;

    try {
      final Map<String, dynamic> dataToSend = {
        'title': formData['title'],
        'price': formData['price'],
        'category': formData['category'].toString().split('.').last,
        'thumbnailUrl': oldThumbnail,
      };

      await _repository.editClass(idToEdit, dataToSend);

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