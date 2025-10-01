import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Color primaryGreen = const Color.fromRGBO(7, 126, 96, 1);

  final List<String> bannerImages = [
    'assets/banner.png',
  ];

  // ==========================
  // 🔹 Helper Widgets (Moved outside the build method)
  // ==========================

  Widget _buildBanner() {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: PageView.builder(
        itemCount: bannerImages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: AssetImage(bannerImages[index]), fit: BoxFit.cover)),
          );
        },
      ),
    );
  }

  Widget _buildProgramIcon(
      String assetPath, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              assetPath,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCourseCard(
      String title, double rating, String price, String imageUrl, List<String> tags) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(imageUrl,
                height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 6,
              children: tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.green.shade100,
                        labelStyle: TextStyle(
                            color: Colors.green.shade900, fontSize: 11),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                const Text('4.5'),
                const Spacer(),
                Text(price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVoucherInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      // Removed redundant margin: const EdgeInsets.symmetric(horizontal: 20),
      // as it's already wrapped in a Padding with 20.0 horizontal.
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Logo di pojok kiri atas
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/handsphone.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          // Column di tengah: teks + tombol
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Redeem Voucher Prakerjamu', // teks baru di atas
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold, // bold
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center, // posisinya di tengah
                  child: SizedBox(
                    width: 250, // lebar teks agar tetap rata kiri
                    child: const Text(
                      'Kamu pengguna Prakerja? Segera redeem vouchermu sekarang juga',
                      textAlign: TextAlign.left, // tetap rata kiri
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    print('Masukkan voucher Prakerja');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: const Text(
                    'Masukkan Voucher Prakerja',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCardWithImage({
    required String title,
    required String imageUrl,
    required int count,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto/banner di atas
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('$count Kelas tersedia',
              style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          const SizedBox(height: 8),
          // Tombol lihat detail jika ingin
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryGreen),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
              child: const Text(
                'Lihat Detail Kelas',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchCard({required String title, required String company}) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row logo + optional space
          Row(
            children: [
              Image.asset(
                'assets/luarsekolahmini.png',
                width: 50, // lebih kecil
                height: 50,
                fit: BoxFit.contain,
              ),
              const Spacer(), // agar logo tetap di kiri
            ],
          ),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(company, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: primaryGreen, size: 16),
              const SizedBox(width: 4),
              const Text('2 Bulan', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 30),
          // Tombol lihat detail proyek (text lebih kecil)
          Center(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryGreen),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
              child: const Text(
                'Lihat Detail Proyek',
                style:
                    TextStyle(color: Colors.black, fontSize: 12), // text lebih kecil
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Kuota peserta
          const Center(
            child: Text(
              'Kuota untuk 100 peserta',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String snippet, String imageUrl) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              snippet,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Baca selengkapnya',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMagangBanner() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage('assets/fotocewe.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ikut magang bisa auto lolos? Bisa Banget! Daftar di magang sekarang.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(7, 126, 96, 1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Lihat Program Magang'),
                )
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  
  // Build Method


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: primaryGreen,
            elevation: 0,
            floating: true,
            snap: true,
            pinned: false,
            expandedHeight: 80,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/mera.png'),
                      radius: 18,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Halo,',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        Text(
                          'Meraditaa',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          size: 26, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Program dari Luarsekolah',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProgramIcon(
                          'assets/prakerja.png', 'Prakerja', () {
                        print('Prakerja clicked');
                      }),
                      _buildProgramIcon(
                          'assets/orangkuning.png', 'Magang+', () {}),
                      _buildProgramIcon(
                          'assets/luarsekolahmini.png', 'Subs', () {}),
                      _buildProgramIcon(
                          'assets/lainnya.png', 'Lainnya', () {}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildVoucherInputCard(),
                  const SizedBox(height: 20),

                  // ===== Kelas Terpopuler =====
                  const Text('Kelas Terpopuler di Prakerja',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCourseCard(
                            'Teknik Pemilahan dan Pengolahan Sampah',
                            4.5,
                            'Rp 1.500.000',
                            'assets/poster1.png',
                            const ['Prakerja', 'SPL']),
                        const SizedBox(width: 12),
                        _buildCourseCard(
                            'Meningkatkan Pertumbuhan Tanaman',
                            4.5,
                            'Rp 1.500.000',
                            'assets/poster2.png',
                            const ['Prakerja']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Lihat Semua Kelas',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),

                  // ===== Akses Semua Kelas (Card seperti kelas) =====
                  const Text('Akses Semua Kelas dengan Berlangganan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSubscriptionCardWithImage(
                          title:
                              'Belajar SwiftUI Untuk Pembuatan Interface',
                          imageUrl: 'assets/poster2.png',
                          count: 5,
                        ),
                        const SizedBox(width: 12),
                        _buildSubscriptionCardWithImage(
                          title: 'Belajar Dart Untuk Pembuatan Aplikasi',
                          imageUrl: 'assets/poster2.png',
                          count: 5,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Lihat Semua',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),

                  // ===== Banner Magang =====
                  _buildMagangBanner(),
                  const SizedBox(height: 24),

                  // ===== Batch Maret (Card seperti kelas) =====
                  const Text('Batch Maret (2 bulan)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  //INI HALAMAN HORIZONTAL CARD MAGANG
                  SizedBox(
                    height: 320, // Sesuaikan tinggi supaya muat logo + teks
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildBatchCard(
                            title: 'Membuat Dashboard SaaS Magang',
                            company: 'Luarsekolah'),
                        const SizedBox(width: 12),
                        _buildBatchCard(
                            title: 'Membuat Dashboard Aplikasi Mobile',
                            company: 'Luarsekolah'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== Artikel =====
                  const Text('Artikel',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildArticleCard(
                            'Penpot’s Flex Layout: Building CSS Layouts I...',
                            'In today’s article, let’s explore how we can use FL...',
                            'assets/thumbnail.png'),
                        const SizedBox(width: 12),
                        _buildArticleCard(
                            'Penpot’s Flex Layout: Building CSS Layouts II...',
                            'In today’s article, let’s explore how we can use FL...',
                            'assets/thumbnail.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Lihat Semua',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primaryGreen, // ini bisa tetap untuk label
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/beranda.png', width: 24, height: 24),
            activeIcon:
                Image.asset('assets/beranda.png', width: 24, height: 24),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/kelas.png', width: 24, height: 24),
            activeIcon: Image.asset('assets/kelas.png', width: 24, height: 24),
            label: 'Kelas',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/kelasku.png', width: 24, height: 24),
            activeIcon:
                Image.asset('assets/kelasku.png', width: 24, height: 24),
            label: 'Kelasku',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/koinls.png', width: 24, height: 24),
            activeIcon: Image.asset('assets/koinls.png', width: 24, height: 24),
            label: 'KoinLS',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/akun.png', width: 24, height: 24),
            activeIcon: Image.asset('assets/akun.png', width: 24, height: 24),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}