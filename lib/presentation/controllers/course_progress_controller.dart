import 'package:get/get.dart';

class CourseProgressController extends GetxController {
  // Menyimpan progres keseluruhan kelas. Default dimulai dari nilai 0.
  var courseProgress = <String, int>{
    'Belajar Dasar Design Grafis': 0,
  }.obs;

  // Fungsi untuk mengambil persen progres untuk UI ProgressBar
  int getProgress(String title) {
    return courseProgress[title] ?? 0;
  }

  // Mengupdate progres secara bertahap berkelipatan 20% berdasarkan jumlah video yang ditonton
  void updateCourseProgress(String courseTitle, int watchedCount) {
    // 1 video = 20%, dibatasi maksimal 100%
    int calculatedProgress = (watchedCount * 20).clamp(0, 100);

    // Update progres berdasarkan judul kelas utama
    courseProgress[courseTitle] = calculatedProgress;
    
    print("Berhasil! Progres kelas '$courseTitle' sekarang menjadi: $calculatedProgress%");
  }

  // Menjaga fungsi lama agar halaman lain tidak error jika sempat memanggilnya
  void markCompleted(String title) {
    courseProgress[title] = 100;
  }

  void resetProgress(String title) {
    courseProgress[title] = 0;
  }
}