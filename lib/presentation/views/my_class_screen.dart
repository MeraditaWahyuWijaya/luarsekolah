import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/course_detail_controller.dart';
import 'course_detail_view.dart';
import '../controllers/course_progress_controller.dart';

const String kBannerAsset = 'assets/banner.png';
const Color _kTeal = Colors.teal;

class MyClassScreen extends StatelessWidget {
  MyClassScreen({super.key});

  // Inject controller agar bisa dipakai di halaman lain
  final CourseProgressController progressController = Get.put(CourseProgressController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Lanjutkan Kembali Progres Belajarmu hari ini!.',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView(
            children: [
              Obx(() => CourseProgressCard(
                    title: 'Membangun Usaha Bengkel',
                    provider: 'Luarsekolah',
                    progress: progressController
                        .getProgress('Membangun Usaha Bengkel'),
                    imageAsset: kBannerAsset,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class CourseProgressCard extends StatelessWidget {
  final String title;
  final String provider;
  final int progress;
  final String imageAsset;

  const CourseProgressCard({
    super.key,
    required this.title,
    required this.provider,
    required this.progress,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Navigasi ke halaman video
      onTap: () {
        Get.to(
          () => const CourseDetailView(),
          arguments: {
            'title': title,
            'videoId': 'dQw4w9WgXcQ',
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(imageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Progress Belajar',
              style: GoogleFonts.montserrat(fontSize: 12),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_kTeal),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$progress%',
                  style: GoogleFonts.montserrat(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
