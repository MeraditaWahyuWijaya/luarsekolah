import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:luarsekolah/presentation/widgets/hover_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryGreen = const Color.fromRGBO(7, 126, 96, 1);

  final List<String> bannerImages = [
    'assets/banner.png',
    'assets/bannercar1.jpg',
    'assets/bannercar2.jpg',
  ];

  int _notificationCount = 3;

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(10), //16
      child: CarouselSlider.builder(
        itemCount: bannerImages.length,
        itemBuilder: (context, index, realIndex) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(bannerImages[index]), 
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 210.0,//150
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          viewportFraction: 1.0,
        ),
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

  Widget _buildVoucherInputCard() {
    return Container(
      padding: const EdgeInsets.all(16), 
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Redeem Voucher Prakerjamu', 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 250,
                    child: const Text(
                      'Kamu pengguna Prakerja? Segera redeem vouchermu sekarang juga',
                      textAlign: TextAlign.left,
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

  Widget _buildSubscriptionCardContent({
    required String title,
    required String imageUrl,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

  Widget _buildBatchCardContent({required String title, required String company}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/luarsekolahmini.png',
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const Spacer(),
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
                    TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
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

  Widget _buildArticleCardContent(String title, String snippet, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen, 
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false, 
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
                      backgroundImage: AssetImage('assets/nailong.jpg'),
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
                    
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none,
                              size: 30, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _notificationCount = 0;
                            });
                          },
                        ),
                        
                        if (_notificationCount > 0)
                          Positioned(
                            right: 8, 
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4), 
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10), 
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16, 
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  _notificationCount > 9 ? '9+' : '$_notificationCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), 
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 20), 
              
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

                    const Text('Kelas Terpopuler di Prakerja',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CourseCardWithHover(
                              title: 'Teknik Pemilahan dan Pengolahan Sampah',
                              rating: 4.5,
                              price: 'Rp 1.500.000',
                              imageUrl: 'assets/poster1.png',
                              tags: const ['Prakerja', 'SPL'],
                          ),
                          CourseCardWithHover(
                              title: 'Meningkatkan Pertumbuhan Tanaman',
                              rating: 4.5,
                              price: 'Rp 1.500.000',
                              imageUrl: 'assets/poster2.png',
                              tags: const ['Prakerja'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Lihat Semua Kelas',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),

                    
                    const Text('Akses Semua Kelas dengan Berlangganan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildSubscriptionCardContent(
                              title: 'Belajar SwiftUI Untuk Pembuatan Interface',
                              imageUrl: 'assets/poster2.png',
                              count: 5,
                            ),
                          ),
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildSubscriptionCardContent(
                              title: 'Belajar Dart Untuk Pembuatan Aplikasi',
                              imageUrl: 'assets/poster2.png',
                              count: 5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Lihat Semua',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 25),

                    _buildMagangBanner(),
                    const SizedBox(height: 24),

                    const Text('Batch Maret (2 bulan)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildBatchCardContent(
                                title: 'Membuat Dashboard SaaS Magang',
                                company: 'Luarsekolah'),
                          ),
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildBatchCardContent(
                                title: 'Membuat Dashboard Aplikasi Mobile',
                                company: 'Luarsekolah'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text('Artikel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildArticleCardContent(
                                'Penpot’s Flex Layout: Building CSS Layouts I...',
                                'In today’s article, let’s explore how we can use FL...',
                                'assets/thumbnail.png'),
                          ),
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildArticleCardContent(
                                'Penpot’s Flex Layout: Building CSS Layouts II...',
                                'In today’s article, let’s explore how we can use FL...',
                                'assets/thumbnail.png'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Lihat Semua',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
//--------------------------------------------HALAMAN TUTOR------------------------------------//
//CARA MEMBUAT CARD 

//kita harus tau nantinya yang akan dimasukkan card itu apa aja,//
//misal judul berarti harus ada tittle//
//rating(karena biasanya pakai koma)= double
//price/image.url=string
//setelah itu kita pakai container untuk membuat box nya nanti muncul dihalaman itu, nah itu nanti di ukur width/height nya 
//setelah itu diberi keterangan (MARGIN) mau di taruh sebelah mana. pakai box decoration untuk membuat card luar, jika mau ada shadow bisa pakai BoxShadow. 
//jika sudah, kita pakai child lalu buat children. 
//nah di children ini kita masukkan hal yang mau ditampilkan didalam box nanti(misal foto,text).
//nah untuk atur didalam box itu, kita gunakan row (untuk atur secara horizontal). 
//kalau mau widgetnya fit sama card kita bisa pakai box.fit.

// CARA MEMBUAT BUTTON DARI IMAGES
//Jika ingin membuat gambar yang bisa dipencet kita harus membuat _buildprogramicon 
//contoh : 
//_buildProgramIcon('assets/prakerja.png', 'Prakerja', () {
//print('Prakerja clicked');
// }),
//Nah yang membuat images bisa di click adalah " () {} " karena akan memproses saat dipencet //

//BIKIN CARD/BOX YANG LATAR BELAKANGNYA FOTO 
//aku bikin box decoration dulu di container, 
//ntar aku isi images yang cons nya decoration images. 
//habis itu aku panggil images dari local. 
//nah untuk ukurannya dibuat fitbox agar memenuhi container.
//dan untuk posisi gambar mau disebelah/rata mana itu pakai alignment