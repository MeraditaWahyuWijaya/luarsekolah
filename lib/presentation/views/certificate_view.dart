import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificateView extends StatelessWidget {
  const CertificateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil nama 'Meradita' yang dikirim dari halaman sebelumnya
    final String userName = Get.arguments['userName'] ?? 'Peserta';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifikat Saya'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/template_sertifikat.png'),
           Positioned(
  top: 130, // Tadi 150, kita kurangi jadi 130 agar LEBIH KE ATAS
  left: 27, // Tambahkan ini untuk menggeser LEBIH KE KIRI. 
            // (Sesuaikan angkanya sampai pas dengan garis di desain Canva kamu)
  child: Text(
    userName,
    style: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF2C3E50),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}