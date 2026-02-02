import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/course_progress_controller.dart';

class CourseDetailView extends StatefulWidget {
  const CourseDetailView({super.key});

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  late YoutubePlayerController _controller;

  // Ambil controller progress yang sudah ada
  final CourseProgressController progressController =
      Get.find<CourseProgressController>();

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>;
    final String videoId = args['videoId'];
    final String title = args['title'];

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Listener untuk mendeteksi video selesai
    _controller.addListener(() {
      if (_controller.value.playerState == PlayerState.ended) {
        progressController.markCompleted(title);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final String title = args['title'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Tonton video sampai selesai untuk menyelesaikan kelas.',
              style: GoogleFonts.montserrat(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
