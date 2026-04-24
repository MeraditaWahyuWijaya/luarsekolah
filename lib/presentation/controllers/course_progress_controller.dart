import 'package:get/get.dart';

class CourseProgressController extends GetxController {
  // Variabel reaktif untuk menyimpan progres kursus (Judul: Persentase)
  var courseProgress = <String, int>{
    'Membangun Usaha Bengkel': 0,
  }.obs;

  // Fungsi untuk mengambil angka progres berdasarkan judul
  int getProgress(String title) {
    return courseProgress[title] ?? 0;
  }

  // Fungsi untuk menandai kursus selesai (100%)
  void markCompleted(String title) {
    courseProgress[title] = 100;
    print("Progres $title berhasil diperbarui menjadi 100%");
  }

  // Opsional: Fungsi untuk reset progres jika diperlukan
  void resetProgress(String title) {
    courseProgress[title] = 0;
  }
}