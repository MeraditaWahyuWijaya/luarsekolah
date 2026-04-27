import 'package:get/get.dart';

class CourseProgressController extends GetxController {
  /* BAGIAN PENTING: 
     Gunakan judul yang SAMA PERSIS dengan yang ada di tampilan kartu kamu.
     Tadi di MyClassScreen kamu pakai 'Belajar Dasar Design Grafis', 
     jadi di sini juga harus sama supaya datanya nyambung.
  */
  var courseProgress = <String, int>{
    'Belajar Dasar Design Grafis': 0,
  }.obs;

  /* Fungsi ini dipanggil oleh UI (Halaman Utama) untuk mengecek 
     berapa persen progres yang harus ditampilkan di Bar.
  */
  int getProgress(String title) {
    return courseProgress[title] ?? 0;
  }

  /* Fungsi ini dipanggil oleh CourseDetailController saat video selesai.
     'title' yang dikirim dari halaman video harus sama dengan kunci di atas.
  */
  void markCompleted(String title) {
    if (courseProgress.containsKey(title)) {
      courseProgress[title] = 100;
      print("Berhasil! Progres $title sekarang sudah 100%");
    } else {
      /* Tips: Jika judul tidak ketemu, kita buatkan data baru 
         supaya aplikasi tidak error dan progres tetap tersimpan.
      */
      courseProgress[title] = 100;
      print("Judul baru dibuat: $title berhasil diselesaikan");
    }
  }

  void resetProgress(String title) {
    courseProgress[title] = 0;
  }
}