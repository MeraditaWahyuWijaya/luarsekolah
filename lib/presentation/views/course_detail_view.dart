import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chewie/chewie.dart';
import '../controllers/course_detail_controller.dart';

class CourseDetailView extends StatelessWidget {
  const CourseDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CourseDetailController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.title,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                const SizedBox(height: 24),
                Obx(() => controller.isVideoFinished.value
                    ? ElevatedButton.icon(
                        onPressed: () {
                          print("Proses download sertifikat...");
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("Download Sertifikat"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
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
    );
  }
}