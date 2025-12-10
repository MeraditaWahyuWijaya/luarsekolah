import 'package:flutter/material.dart';
import 'package:luarsekolah/presentation/views/register_screen.dart';
import 'package:luarsekolah/presentation/views/login_screen.dart';
import 'package:luarsekolah/presentation/views/home_screen.dart';
//animasi di page
class AppRoutes {
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
  static const page2 = '/page2'; // Nama rute untuk halaman tujuan
}

Route<dynamic> onAppGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    
    case AppRoutes.register:
      return PageRouteBuilder(
        settings: settings,
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => const RegistrationScreen(), 
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );

    case AppRoutes.login:
      return PageRouteBuilder(
        settings: settings, 
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(), 
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var scaleTween = Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut));
          
          return ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          );
        },
      );
      

      case AppRoutes.home:
  return PageRouteBuilder(
    settings: settings, 
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(), 
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Scale 4.0 -> 1.0 (Zoom In)
      var scaleTween = Tween<double>(begin: 4.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut));
      
      return ScaleTransition(
        scale: animation.drive(scaleTween),
        child: child,
          );
        },
      );
    default:
      return MaterialPageRoute(builder: (context) => const RegistrationScreen());
  }
}