import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificateView extends StatelessWidget {
  const CertificateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data nama yang dikirim saat tombol diklik
    final String userName = Get.arguments['userName'] ?? 'Meradita';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifikat Saya'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Gambar dari Canva yang sudah kamu masukkan ke assets
            Image.asset('assets/images/template_sertifikat.png'),
            
            // Nama kamu yang akan muncul otomatis di atas gambar
            Positioned(
              top: 155, // Atur angka ini (naik/turun) sampai pas di posisi nama
              child: Text(
                userName,
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50), // Warna elegan gelap
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}