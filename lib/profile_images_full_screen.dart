import 'package:flutter/material.dart';

class ProfileImageFullScreen extends StatelessWidget {
  const ProfileImageFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Atur latar belakang menjadi hitam agar gambar menonjol
      backgroundColor: Colors.black, 
      
      appBar: AppBar(
        // Buat AppBar transparan dan tidak berbayang
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Atur warna ikon (tombol back) menjadi putih
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      
      // Body harus berada di tengah untuk menampilkan gambar secara penuh
      body: Center(
        child: Hero(
          // Tag Hero harus SAMA PERSIS dengan tag di ProfileFormScreen.dart
          tag: 'profile-image-hero-tag', 
          
          // Memuat gambar yang sama di tengah layar
          child: Image.asset(
            'assets/nailong.jpg', 
            // Mengatur gambar agar mengisi ruang sebanyak mungkin tanpa terpotong
            fit: BoxFit.contain, 
          ),
        ),
      ),
    );
  }
}