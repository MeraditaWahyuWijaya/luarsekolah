import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chewie/chewie.dart';
import '../controllers/course_detail_controller.dart';
import 'certificate_view.dart'; 

class CourseDetailView extends StatelessWidget {
  const CourseDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseDetailController());

    return Scaffold(
      /* SafeArea digunakan supaya konten tidak tertutup notch atau bar baterai */
      body: SafeArea( 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              /* BAGIAN HEADER CUSTOM: LOGO DAN TULISAN KELAS SAYA */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    /* Logo Luarsekolah di pojok kiri */
                    Image.asset(
                      'assets/luarsekolahlogo.png',
                      height: 24, /* Tinggi logo disamakan dengan ukuran teks */
                      fit: BoxFit.contain,
                    ),
                    
                    /* Tulisan Kelas Saya di posisi tengah */
                    Expanded(
                      child: Center(
                        child: Text(
                          'Kelas Saya',
                          style: GoogleFonts.montserrat(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    
                    /* Spacer di ujung kanan agar tulisan tetap stabil di tengah */
                    const SizedBox(width: 40), 
                  ],
                ),
              ),

              /* WIDGET PEMUTAR VIDEO */
              GetBuilder<CourseDetailController>(
                builder: (_) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: controller.chewieController != null
                        ? Chewie(controller: controller.chewieController!)
                        : const Center(
                            child: CircularProgressIndicator(color: Colors.teal),
                          ),
                  );
                },
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tonton video sampai selesai untuk menyelesaikan kelas.',
                      style: GoogleFonts.montserrat(fontSize: 14),
                    ),

                    const SizedBox(height: 32),

                    /* BAGIAN DESKRIPSI MATERI */
                    Text(
                      'Tentang Kelas Ini',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Design Grafis adalah bentuk komunikasi visual yang menggunakan elemen seperti tipografi, ilustrasi, dan fotografi untuk menyampaikan pesan. Di kelas ini, kamu telah mempelajari prinsip dasar hirarki visual dan tata letak yang efektif untuk membuat karya yang estetik dan komunikatif bagi audiens.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 40),
                    
                    /* LOGIKA TOMBOL SERTIFIKAT */
                    Obx(() => controller.isVideoFinished.value
                        ? ElevatedButton.icon(
                            onPressed: () {
                              /* Navigasi ke halaman sertifikat */
                              Get.to(
                                () => const CertificateView(),
                                arguments: {
                                  'userName': 'Meradita', 
                                  'title': controller.title,
                                },
                              );
                            },
                            icon: const Icon(Icons.workspace_premium),
                            label: const Text("Lihat Sertifikat"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Sertifikat akan tersedia setelah video selesai.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(color: Colors.grey[700]),
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}