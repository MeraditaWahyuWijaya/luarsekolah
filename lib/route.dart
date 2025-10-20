import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: CustomAnimate()));
}

class ScalePageRoute extends PageRouteBuilder {
  final Widget child;

  ScalePageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeOut;

            var scaleTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));
            
            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: child,
            );
          },
        );
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget child;

  SlidePageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOut;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}

class CustomAnimate extends StatelessWidget {
  const CustomAnimate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Utama')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(SlidePageRoute(
                  child: const Page2(),
                ));
              },
              child: const Text('Ke Halaman 2 dengan SLIDE'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(ScalePageRoute(
                  child: const Page2(),
                ));
              },
              child: const Text('Ke Halaman 2 dengan SCALE'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman 2 (Tujuan)')),
      body: const Center(
          child: Text(
              'Ini adalah halaman yang masuk dengan Transisi Kustom.')),
    );
  }
}