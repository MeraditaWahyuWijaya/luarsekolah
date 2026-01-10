import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart'; 
import '../../data/repositories/class_repository.dart';
import '../../domain/entities/class_model.dart';
import '../../data/providers/local_notification_service.dart'; 
import '../../data/providers/notification_service.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';


enum ClassCategory { populer, spl }

class ClassController extends GetxController {
  final ClassRepository repository;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  ClassController(this.repository);

  // Observable Variables
  var isLoading = false.obs;
  var isFormVisible = false.obs;
  var isEditMode = false.obs;
  var selectedCategory = ClassCategory.populer.obs;
  var classToEdit = Rxn<ClassModel>();
  var filteredClasses = <ClassModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses(selectedCategory.value);
  }

  // Fungsi untuk menampilkan form tambah
  void showAddForm() {
    isEditMode.value = false;
    classToEdit.value = null;
    isFormVisible.value = true;
  }

  // Fungsi untuk menampilkan form edit
  void showEditForm(ClassModel data) {
    isEditMode.value = true;
    classToEdit.value = data;
    isFormVisible.value = true;
  }

  // Fungsi untuk menyembunyikan form
  void hideForm() {
    isFormVisible.value = false;
    classToEdit.value = null;
    isEditMode.value = false;
  }

  Future<void> selectCategory(ClassCategory category) async {
    selectedCategory.value = category;
    await fetchClasses(category);
  }

  // Mengambil daftar kelas berdasarkan kategori
  Future<void> fetchClasses(ClassCategory category) async {
    try {
      isLoading.value = true;
      final data = await repository.getFilteredClasses(
          category == ClassCategory.populer ? 'Populer' : 'SPL');
      filteredClasses.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi utama untuk menambahkan kelas baru
Future<void> submitAddClass(Map<String, dynamic> data, {File? imageFile}) async {
  try {
    String newClassId;
    if (imageFile != null) {
      newClassId = await repository.addClassWithImage(data, imageFile);
    } else {
      newClassId = await repository.addClassWithoutImage(data);
    }

    // Local Notification
    LocalNotificationService.show(
      title: "Kelas Baru Berhasil Ditambahkan ✅",
      body: "Kelas ${data['title']} kini tersedia di aplikasi Anda.",
      payload: newClassId,
    );

    // Snackbar
    Get.snackbar(
      'Sukses',
      'Kelas "${data['title']}" berhasil ditambahkan!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade400,
      colorText: Colors.white,
    );

    // FCM topic notification
    await NotificationService().sendTopicNotification(
      topic: "kelas",
      title: "Kelas Baru Telah Dirilis 🎉",
      body: "Kelas ${data['title']} kini tersedia!",
      data: {"className": data['title'], "classId": newClassId},
    );

    await fetchClasses(selectedCategory.value);
    hideForm();
  } catch (e) {
    Get.snackbar(
      'Gagal menambah Kelas',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
    );
  }
}


  // Fungsi untuk mengedit kelas yang sudah ada
  Future<void> submitEditClass(Map<String, dynamic> data, {File? imageFile}) async {
    if (classToEdit.value == null) return;
    try {
      isLoading.value = true;
      await repository.editClass(classToEdit.value!.id, data);
      await fetchClasses(selectedCategory.value);
      hideForm();
      Get.snackbar(
        'Sukses',
        'Kelas "${data['title']}" berhasil diubah!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk menghapus kelas
  Future<void> deleteClass(String id) async {
    try {
      isLoading.value = true;
      await repository.deleteClass(id);
      await fetchClasses(selectedCategory.value);
      Get.snackbar(
        'Dihapus',
        'Kelas berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade400,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}