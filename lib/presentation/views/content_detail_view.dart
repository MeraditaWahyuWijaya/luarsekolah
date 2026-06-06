import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentDetailView extends StatelessWidget {
  const ContentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data yang dikirim dari Home
    final data = Get.arguments as Map<String, dynamic>;

    final String title = data['title'];
    final String content = data['content'];
    final String image = data['image'];
    final String type = data['type'] ?? 'article';

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(_getAppBarTitle(type)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image
            Image.asset(
              image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul konten
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Meta info disesuaikan berdasarkan tipe konten
                  Text(
                    _getMetaText(type),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Isi utama konten
                  Text(
                    content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menentukan judul AppBar berdasarkan tipe konten
  String _getAppBarTitle(String type) {
    switch (type) {
      case 'course':
        return 'Detail Kelas';
      case 'batch':
        return 'Detail Program';
      default:
        return 'Artikel';
    }
  }

  // Menentukan teks meta berdasarkan tipe konten
  String _getMetaText(String type) {
    switch (type) {
      case 'course':
        return 'Kelas • Luarsekolah';
      case 'batch':
        return 'Program • Luarsekolah';
      default:
        return 'Artikel • Luarsekolah';
    }
  }
}
