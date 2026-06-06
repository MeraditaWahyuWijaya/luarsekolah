import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../controllers/course_progress_controller.dart';

class CourseDetailController extends GetxController {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  
  var isVideoFinished = false.obs;

  // Daftar 5 rentetan video yang harus diselesaikan
  final List<String> videoAssets = [
    "assets/materidesign.mp4", // Video ke-1 (20%)
    "assets/video1.mp4",       // Video ke-2 (40%)
    "assets/video2.mp4",       // Video ke-3 (60%)
    "assets/video3.mp4",       // Video ke-4 (80%)
    "assets/video4.mp4",       // Video ke-5 (100% + Sertifikat Terbuka)
  ];

  // Indeks video yang sedang aktif/diputar saat ini (0 sampai 4)
  var currentVideoIndex = 0.obs;

  // Menyimpan daftar indeks video yang sudah sukses ditonton sampai habis
  var watchedVideoIndices = <int>{}.obs; 
  final int targetVideos = 5;

  // Mengambil judul kelas utama dari arguments
  final String title = Get.arguments['title'];

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  // Getter untuk mengecek apakah ke-5 video sudah selesai ditonton semua
  bool get isEligibleForCertificate => watchedVideoIndices.length >= targetVideos;

  // Fungsi untuk menginisialisasi video berdasarkan indeks aktif
  Future<void> initializePlayer() async {
    // Bersihkan memori dari controller video sebelumnya sebelum memutar yang baru
    await videoPlayerController?.dispose();
    chewieController?.dispose();
    
    isVideoFinished.value = false;

    // Ambil aset video dari daftar berdasarkan indeks saat ini
    videoPlayerController = VideoPlayerController.asset(videoAssets[currentVideoIndex.value]);
    
    await videoPlayerController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: videoPlayerController!.value.aspectRatio,
    );

    // Listener untuk mendeteksi ketika durasi video telah habis
    videoPlayerController!.addListener(() {
      if (videoPlayerController!.value.isInitialized) {
        if (videoPlayerController!.value.position >= videoPlayerController!.value.duration) {
          if (!isVideoFinished.value) {
            isVideoFinished.value = true;
            
            // Masukkan indeks video yang tamat ke dalam Set data tontonan
            watchedVideoIndices.add(currentVideoIndex.value); 

            try {
              // Hubungkan ke CourseProgressController untuk update progress bar secara bertahap
              final progressController = Get.find<CourseProgressController>();
              progressController.updateCourseProgress(title, watchedVideoIndices.length);
            } catch (e) {
              print("CourseProgressController tidak ditemukan: $e");
            }

            // Otomatis putar video berikutnya secara berurutan jika masih ada sisa rentetan video
            if (currentVideoIndex.value < videoAssets.length - 1) {
              nextVideo();
            }
          }
        }
      }
    });

    update();
  }

  // Fungsi untuk maju ke video berikutnya
  void nextVideo() {
    if (currentVideoIndex.value < videoAssets.length - 1) {
      currentVideoIndex.value++;
      initializePlayer();
    }
  }

  // Fungsi jika ingin berpindah video secara manual lewat list playlist di UI
  void changeVideo(int index) {
    if (index >= 0 && index < videoAssets.length) {
      currentVideoIndex.value = index;
      initializePlayer();
    }
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}