import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/data/providers/api_service.dart';
import 'package:luarsekolah/presentation/controllers/class_controllers.dart';

class AddClassController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final namaKelasController = TextEditingController(); 
  final deskripsiController = TextEditingController(); 
  final isLoading = false.obs;
  
  void handleSimpanKelas() async {
    if (namaKelasController.text.isEmpty) {
      Get.snackbar('Gagal', 'Nama kelas tidak boleh kosong');
      return;
    }
    
    const String dummyPrice = '1500000'; 
    const String dummyCategory = 'populer';
    const String dummyThumbnailUrl = 'https://picsum.photos/400/300';

    isLoading.value = true;

    try {
      await _apiService.createCourseWithoutImage(
        name: namaKelasController.text,
        price: dummyPrice, 
        category: dummyCategory, 
        thumbnailUrl: dummyThumbnailUrl, 
      ); 

      Get.snackbar('Berhasil', 'Kelas "${namaKelasController.text}" berhasil ditambahkan!', 
          backgroundColor: const Color.fromRGBO(7, 126, 96, 1), colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);

      if (Get.isRegistered<ClassController>()) {
          Get.find<ClassController>().fetchClasses(); 
      }
      
      Get.back();

    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menambahkan kelas: ${e.toString().replaceFirst('Exception: ', '')}', 
          backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    namaKelasController.dispose();
    deskripsiController.dispose();
    super.onClose();
  }
}