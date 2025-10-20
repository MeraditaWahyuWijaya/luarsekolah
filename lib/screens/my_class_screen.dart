import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../custom_field.dart'; 

const String kBannerAsset = 'assets/banner.png'; 
const Color _kTeal = Colors.teal; 

class MyClassScreen extends StatelessWidget {
  const MyClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Tab> tabs = <Tab>[
      Tab(text: 'Kelas Prakerja'),
      Tab(text: 'Kelas SPL'),
      Tab(text: 'Kelas Lain'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Ruang untuk status bar
          const SizedBox(height: 40), 
          
          // Greeting Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Lanjutkan Kembali Progres Belajarmu,\nMeradita.',
              // Menggunakan Montserrat
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          // Tab Bar (Switchable Bar)
          SizedBox(
            height: 48,
            child: TabBar(
              isScrollable: true,
              tabs: tabs,
              labelColor: _kTeal,
              unselectedLabelColor: Colors.grey,
              indicatorColor: _kTeal,
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.label,
              
              // Font Montserrat, Bold ketika aktif
              labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Colors.tealAccent),

          // Tab View Area
          Expanded(
            child: TabBarView(
              children: [
                _CourseList(), 
                const Center(child: Text('Konten Kelas SPL')),
                const Center(child: Text('Konten Kelas Lain')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget List Kursus
class _CourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: const <Widget>[
        CourseProgressCard(
          title: 'Membangun Usaha Bengkel',
          provider: 'Luarsekolah',
          progress: 0,
          imageAsset: kBannerAsset,
        ),
        CourseProgressCard(
          title: 'Pembuatan Pestisida Ramah Lingkungan untuk Petani Tera...',
          provider: 'Luarsekolah',
          progress: 0,
          imageAsset: kBannerAsset,
        ),
      ],
    );
  }
}

// Widget untuk Kartu Kursus (Sudah termasuk Progress Line dan Font Montserrat)
class CourseProgressCard extends StatelessWidget {
  final String title;
  final String provider;
  final int progress;
  final String imageAsset;

  const CourseProgressCard({
    required this.title,
    required this.provider,
    required this.progress,
    required this.imageAsset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      // Menggunakan Montserrat
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, 
                        fontSize: 14, 
                        color: Colors.black87
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          provider, 
                          // Menggunakan Montserrat
                          style: GoogleFonts.montserrat(fontSize: 12, color: Colors.grey)
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle, color: _kTeal, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),

          // Progress Label
          Text(
            'Progress Belajar',
            // Menggunakan Montserrat
            style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),

          // Progress Line
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(_kTeal),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              // Progress Percentage Text
              Expanded(
                flex: 1,
                child: Text(
                  '${progress}%',
                  // Menggunakan Montserrat
                  style: GoogleFonts.montserrat(fontSize: 12, color: Colors.black),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          
          const Divider(height: 24, thickness: 1, color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }
}