import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:luarsekolah/presentation/widgets/hover_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luarsekolah/data/providers/firebase_auth_service.dart';
import 'dart:io'; // untuk FileImage
import 'package:shared_preferences/shared_preferences.dart'; // untuk simpan path foto
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/views/content_detail_view.dart';
import 'package:image_picker/image_picker.dart';
 //isi artikel 


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  String? profilePhotoPath; 
  final Color primaryGreen = const Color.fromRGBO(7, 126, 96, 1);
  final User? user = FirebaseAuth.instance.currentUser; // ambil user di build atau initState
  final List<String> bannerImages = [
    'assets/banner.png',
    'assets/bannercar1.jpg',
    'assets/bannercar2.jpg',
  ];
    bool isUploaded = false;
    List<Map<String, dynamic>> notifications = [];

     int get _notificationCount =>
      notifications.where((n) => n['isRead'] == false).length;

     void listenClassNotifications() {
  if (user == null) return;

  FirebaseFirestore.instance
      .collection('class_notifications')
      .where('userId', isEqualTo: user!.uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .listen((snapshot) {
    setState(() {
      notifications = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'isRead': doc['isRead'],
        };
      }).toList();
    });
  });
}
Future<void> openCustomerServiceEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'luarsekolah@gmail.com',
      query: 'subject=Bantuan Aplikasi&body=Halo tim LuarSekolah,%0A%0ASaya membutuhkan bantuan terkait...',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }



   // initState untuk load foto profil
  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
     listenClassNotifications();
  }

  Future<void> _loadProfilePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePhotoPath = prefs.getString('userProfilePhoto');
    });
  }

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
    Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isUploaded = true;
      });
    }
  }
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
         Padding(
  // Memberi Padding hanya di sebelah KIRI, 
  // yang secara efektif memaksa Center untuk bergeser ke KANAN
  padding: const EdgeInsets.only(left: 40.0), // Sesuaikan nilai 40.0
  child: Center(
  child: Column(
    // ✨ Tambahkan properti ini untuk menengahkan anak-anak secara horizontal
    crossAxisAlignment: CrossAxisAlignment.center, 
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        'Upload Bukti Transfer',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 6),
      // Tidak perlu lagi menggunakan Align di sini, 
      // cukup CrossAxisAlignment.center di Column sudah menengahkan SizedBox
      SizedBox( 
        width: 250,
        child: const Text(
          'Kamu pengguna Luarsekolah? Segera redeem dengan upload bukti transfermu sekarang juga',
          // Ubah textAlign menjadi TextAlign.center agar teks di tengah di dalam SizedBox
          textAlign: TextAlign.center, 
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
                const SizedBox(height: 15),
               OutlinedButton(
  onPressed: isUploaded ? null : () async {
    // Fungsi untuk ambil foto
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isUploaded = true; // Mengubah status jadi berhasil
      });
    }
  },
  style: OutlinedButton.styleFrom(
    // Warna border jadi abu-abu kalau sudah berhasil
    side: BorderSide(color: isUploaded ? Colors.grey : primaryGreen),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  child: Text(
    isUploaded ? 'Berhasil mengaktifkan kelas' : 'Upload Bukti Transfer',
    style: TextStyle(
      fontSize: 14, 
      color: isUploaded ? primaryGreen : Colors.black,
      fontWeight: isUploaded ? FontWeight.bold : FontWeight.normal,
    ),
  ),
)
              ],
            ),
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

  Widget _buildArticleCardContent(String title, String snippet, String imageUrl, String fullContent) {
    return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      Get.to(
        () => const ContentDetailView(),
        arguments: {
          'title': title,
          'content': fullContent,
          'image': imageUrl,
          'type': 'article',
        },
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            snippet,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          const Text(
            'Baca selengkapnya',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
                   CircleAvatar(
  backgroundImage: profilePhotoPath != null
      ? FileImage(File(profilePhotoPath!)) // pakai foto terbaru
      : user?.photoURL != null
          ? NetworkImage(user!.photoURL!)
          : const AssetImage('assets/nailong.jpg') as ImageProvider,
  radius: 18,
),

                    const SizedBox(width: 12),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          'Halo,',
                          style:
                              TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        Text(
                          user?.displayName ?? 'User',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
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

                    const Text('Kelas Terpopuler di Luarsekolah',
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
                              tags: const ['Tersedia'], //prakerja hijau 
                          ),
                          CourseCardWithHover(
                              title: 'Meningkatkan Pertumbuhan Tanaman',
                              rating: 4.5,
                              price: 'Rp 1.500.000',
                              imageUrl: 'assets/poster2.png',
                              tags: const ['Tersedia'],
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
                              imageUrl: 'assets/ui.jpg',
                              count: 5,
                            ),
                          ),
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildSubscriptionCardContent(
                              title: 'Belajar Dart Untuk Pembuatan Aplikasi',
                              imageUrl: 'assets/dart.jpg',
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
                      height: 303,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildArticleCardContent(
                                  'Transformasi Digital Pendidikan: Tantangan dan Solusinya',
                                  'Artikel ini membahas secara mendalam bagaiman...',
                                  'assets/artikel1.png',
                                  '''     Transformasi digital dalam dunia pendidikan kini bukan lagi sekadar tren, melainkan sebuah kebutuhan mendasar untuk menyiapkan generasi yang kompeten di era teknologi. Secara esensi, proses ini melibatkan integrasi teknologi informasi ke dalam seluruh aspek pembelajaran, mulai dari manajemen kurikulum hingga interaksi di ruang kelas virtual. Namun, transisi ini menghadapi tantangan besar, terutama terkait kesenjangan akses digital di berbagai daerah. Ketidaksiapan infrastruktur jaringan dan keterbatasan perangkat keras bagi siswa di wilayah terpencil sering kali memperlebar jurang kualitas pendidikan. Selain itu, hambatan muncul dari sisi sumber daya manusia, di mana masih banyak tenaga pendidik yang membutuhkan adaptasi lebih dalam untuk menguasai platform pembelajaran digital secara efektif agar materi yang disampaikan tetap menarik dan tidak membosankan bagi siswa.
\n\nUntuk mengatasi hambatan tersebut, diperlukan langkah strategis yang komprehensif dari berbagai pihak. Pemerintah dan institusi pendidikan perlu memprioritaskan pembangunan infrastruktur digital yang merata serta menyediakan platform pembelajaran yang ringan dan mudah diakses melalui perangkat seluler. Peningkatan literasi digital bagi guru juga menjadi kunci, agar mereka mampu memanfaatkan fitur-fitur modern seperti sistem manajemen pembelajaran (LMS) berbasis cloud yang memungkinkan distribusi materi secara real-time dan interaktif. Selain itu, aspek keamanan data pribadi siswa harus menjadi prioritas utama dalam setiap pengembangan aplikasi pendidikan guna membangun kepercayaan masyarakat terhadap ekosistem digital. Dengan kolaborasi yang kuat antara teknologi dan kesiapan SDM, transformasi digital diharapkan mampu menciptakan akses pendidikan yang lebih inklusif, fleksibel, dan relevan dengan tuntutan zaman.'''),
                          ),
                          HoverEffectWrapper(
                            width: 200,
                            child: _buildArticleCardContent(
                                'Menerapkan Pembelajaran Berbasis Proyek (PBL)...',
                                'Pembelajaran Berbasis Proyek (Project-Based Learn...',
                                'assets/artikel2.jpg',
                                '''   Penerapan metode Problem-Based Learning (PBL) dalam ekosistem pendidikan digital mampu mentransformasi peran siswa dari penerima informasi pasif menjadi pemecah masalah yang aktif dan kolaboratif. Melalui pendekatan ini, siswa dihadapkan pada skenario dunia nyata yang relevan dengan bidang minat mereka, sehingga proses belajar tidak lagi terasa teoretis melainkan lebih aplikatif dan bermakna. 
                                Dengan dukungan teknologi seperti platform kolaborasi daring dan akses literasi digital yang luas, PBL memfasilitasi pengembangan berpikir kritis serta keterampilan teknis secara simultan, yang pada akhirnya sangat efektif untuk membangun kemandirian belajar dan kesiapan profesional di masa depan.'''),
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