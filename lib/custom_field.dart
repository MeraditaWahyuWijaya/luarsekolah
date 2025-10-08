// lib/widgets/custom_form_field.dart (Kode yang disarankan)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  // Tambahkan FocusNode dan Input Action jika perlu, tapi kita fokus pada yang ada
  final TextInputAction? textInputAction;
  final bool? obscureText;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false, // Menentukan apakah ini input password
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    // Di sini kita TIDAK akan menangani state visibility (seperti ikon mata)
    // Jika Anda ingin mengurus visibility password di sini, widget ini harus menjadi StatefulWidget.
    // Untuk saat ini, kita akan anggap password field ditangani di ProfileFormScreen
    
    return TextFormField(
      controller: controller, // <-- Terhubung ke controller
      keyboardType: keyboardType, // <-- Terhubung ke jenis keyboard
      textInputAction: textInputAction,
      obscureText: isPassword, // <-- Digunakan jika isPassword = true
      validator: validator, // <-- Terhubung ke validator
      
      decoration: InputDecoration(
        labelText: label, // <-- Terhubung ke label yang dikirim
        labelStyle: GoogleFonts.montserrat(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}