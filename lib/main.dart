import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'bindings/todo_binding.dart'; 
import 'screens/coin_ls_screen.dart';
import 'login_screen.dart'; 
import 'register_screen.dart'; 

class AppRoutes {
  static const String register = '/register'; 
  static const String login = '/login'; 
  static const String todoDashboard = '/todo'; 
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
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Halaman Login")),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Halaman Register")),
    );
  }
}