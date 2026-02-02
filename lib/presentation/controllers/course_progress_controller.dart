import 'package:get/get.dart';

class CourseProgressController extends GetxController {
  // Menyimpan progress setiap kelas
  // Key: judul kelas (sementara)
  // Value: progress 0 - 100
  final RxMap<String, int> progressMap = <String, int>{}.obs;

  // Ambil progress kelas
  int getProgress(String courseTitle) {
    return progressMap[courseTitle] ?? 0;
  }

  // Tandai kelas selesai
  void markCompleted(String courseTitle) {
    progressMap[courseTitle] = 100;
  }
}

