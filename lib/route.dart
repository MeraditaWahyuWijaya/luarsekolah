import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: CustomAnimate()));
}

// Ubah nama kelas menjadi PascalCase (CustomAnimate) untuk konvensi Flutter yang baik
class CustomAnimate extends StatelessWidget {
  const CustomAnimate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Utama')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Panggil fungsi pembuat route
            Navigator.of(context).push(_createSlideRoute());
          },
          child: const Text('Ke Halaman 2 dengan Transisi Halus'),
        ),
      ),
    );
  }
}

// Fungsi yang membuat route dengan Slide Transition
Route<void> _createSlideRoute() {
  return PageRouteBuilder(
    // Definisikan halaman tujuan
    pageBuilder: (context, animation, secondaryAnimation) => const Page2(),
    
    // Tambahkan durasi transisi
    transitionDuration: const Duration(milliseconds: 400),

    // Tambahkan logika animasi di sini!
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 1. Definisikan Titik Mulai dan Akhir
      const begin = Offset(1.0, 0.0); // Mulai dari kanan (di luar layar)
      const end = Offset.zero;       // Berakhir di posisi normal (di tengah layar)
      const curve = Curves.easeOut;  // Kurva untuk nuansa pergerakan yang halus

      // 2. Gabungkan Tween dan Curve
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      // 3. Kembalikan widget animasi
      return SlideTransition(
        position: animation.drive(tween),
        child: child, // Ini adalah Page2
      );
    },
  );
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman 2')),
      body: const Center(child: Text('Ini adalah halaman yang masuk dengan Slide Transition.')),
    );
  }
}
// void navigateToMainScreen(BuildContext context) {
  // Ganti MaterialPageRoute standar
  // Navigasi ke MainScreenWithNavBar dengan transisi Slide Halus
  //Navigator.pushReplacement(
    //context,
    //createCustomSlideRoute(const MainScreenWithNavBar()),
  //);
//}