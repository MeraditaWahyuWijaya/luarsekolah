import 'dart:io';
import 'package:get/get.dart';
import '../../data/repositories/class_repository.dart';
import '../../domain/entities/class_model.dart';
import '../../data/providers/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; //nambahin ini ya


enum ClassCategory { populer, spl }

class ClassController extends GetxController {
  final ClassRepository repository;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  ClassController(this.repository);

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

  void showAddForm() {
    isEditMode.value = false;
    classToEdit.value = null;
    isFormVisible.value = true;
  }

  void showEditForm(ClassModel data) {
    isEditMode.value = true;
    classToEdit.value = data;
    isFormVisible.value = true;
  }

  void hideForm() {
    isFormVisible.value = false;
    classToEdit.value = null;
    isEditMode.value = false;
  }

  Future<void> selectCategory(ClassCategory category) async {
    selectedCategory.value = category;
    await fetchClasses(category);
  }

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

  Future<void> submitAddClass(Map<String, dynamic> data, {File? imageFile}) async {
  try {
    isLoading.value = true;
    if (imageFile != null) {
      await repository.addClassWithImage(data, imageFile);
    } else {
      await repository.addClassWithoutImage(data);
    }

    // Kirim notifikasi otomatis setelah kelas berhasil ditambahkan
    await NotificationService().sendTopicNotification(
      topic: "kelas",
      title: "Kelas Baru Ditambahkan 🎉",
      body: "Kelas ${data['title']} kini tersedia!",
      data: {"className": data['title']},
    );

    await fetchClasses(selectedCategory.value);
    hideForm();
  } catch (e) {
    errorMessage.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}


  Future<void> submitEditClass(Map<String, dynamic> data, {File? imageFile}) async {
    if (classToEdit.value == null) return;
    try {
      isLoading.value = true;
      await repository.editClass(classToEdit.value!.id, data);
      await fetchClasses(selectedCategory.value);
      hideForm();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteClass(String id) async {
    try {
      isLoading.value = true;
      await repository.deleteClass(id);
      await fetchClasses(selectedCategory.value);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
