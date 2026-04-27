import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../controllers/course_progress_controller.dart';

class CourseDetailController extends GetxController {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  
  var isVideoFinished = false.obs;
  
  final String title = Get.arguments['title'];

  @override
  void onInit() {
    super.onInit();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    // GANTI DI SINI: Dari networkUrl menjadi asset
    videoPlayerController = VideoPlayerController.asset("assets/materidesign.mp4");
    
    await videoPlayerController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: videoPlayerController!.value.aspectRatio,
    );

    videoPlayerController!.addListener(() {
      if (videoPlayerController!.value.isInitialized) {
        if (videoPlayerController!.value.position >= videoPlayerController!.value.duration) {
          if (!isVideoFinished.value) {
            isVideoFinished.value = true;
            
            try {
              final progressController = Get.find<CourseProgressController>();
              progressController.markCompleted(title);
            } catch (e) {
              print("Controller tidak ditemukan: $e");
            }
          }
        }
      }
    });

    update();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }
}