import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/routes/route.dart'; 

class RegisterController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isRecaptchaVerified = false.obs;

  RxBool get hasMinLength => (password.value.length >= 8).obs;
  RxBool get hasUppercase => (password.value.contains(RegExp(r'[A-Z]'))).obs;
  RxBool get hasNumberOrSymbol => (password.value.contains(RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]'))).obs;
  
  RxBool get isPasswordAllValid => RxBool(
    hasMinLength.value && hasUppercase.value && hasNumberOrSymbol.value
  );

  RxBool get isFormValid => RxBool(
    !isLoading.value &&
    isRecaptchaVerified.value &&
    name.value.isNotEmpty &&
    GetUtils.isEmail(email.value) &&
    isPasswordAllValid.value
  );

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void updateRecaptcha(bool? value) {
    isRecaptchaVerified.value = value ?? false;
  }

  Future<void> handleRegistration() async {
    if (!isFormValid.value) {
      Get.snackbar(
        'Perhatian', 
        'Harap lengkapi semua data dan kriteria password dengan benar.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.yellow.shade800,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      
      Get.offAllNamed(AppRoutes.home);

      Get.snackbar(
        'Sukses', 
        'Akun berhasil dibuat!', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Email sudah terdaftar.';
      } else {
        errorMessage = 'Registrasi Gagal: ${e.message}';
      }

      Get.snackbar(
        'Error', 
        errorMessage, 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Terjadi kesalahan tak terduga.', 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }
}