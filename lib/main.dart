import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:luarsekolah/presentation/bindings/todo_binding.dart';
import 'package:luarsekolah/presentation/bindings/class_binding.dart'; 
import 'package:luarsekolah/presentation/views/coin_ls_screen.dart';
import 'package:luarsekolah/presentation/views/class_screen.dart';
import 'package:luarsekolah/presentation/views/login_screen.dart'; 
import 'package:luarsekolah/presentation/views/register_screen.dart'; 
import 'package:luarsekolah/presentation/views/coin_ls_screen.dart';

class AppRoutes {
  static const String register = '/register'; 
  static const String login = '/login'; 
  static const String todoDashboard = '/todo'; 
  static const String classDashboard = '/kelas'; 
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LuarSekolah App',
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, 
      
      initialRoute: AppRoutes.register, 
      
      getPages: [
        GetPage(
          name: AppRoutes.register,
          page: () => const RegistrationScreen(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
        ),
        
        GetPage(
          name: AppRoutes.todoDashboard,
          page: () => const TodoDashboardPage(),
          binding: TodoBinding(),
        ),
        GetPage(
        name: AppRoutes.classDashboard, 
        page: () => KelasPopulerScreenClean(),
        binding: ClassBinding(),
      ),
      ],
    );
  }
}