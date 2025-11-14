import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luarsekolah/presentation/views/login_screen.dart';
import 'package:luarsekolah/presentation/views/register_screen.dart';
import 'package:luarsekolah/presentation/views/class_screen.dart';
import 'package:luarsekolah/presentation/widgets/custom_field.dart';
import 'package:luarsekolah/presentation/controllers/auth_check_controller.dart';
import 'package:luarsekolah/presentation/bindings/todo_binding.dart';

class AppRoutes {
  static const String authCheck = '/';
  static const String register = '/register';
  static const String login = '/login';
  static const String classDashboard = '/kelas';
  static const String mainDashboard = '/main';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('Firebase initialized successfully');

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      print('User not logged in');
    } else {
      print('User logged in: ${user.email}');
    }
  });

  FirebaseFirestore.instance
      .collection('test')
      .doc('check')
      .set({'status': 'ok'})
      .then((_) => print('Firestore write success'))
      .catchError((e) => print('Firestore error: $e'));

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
      initialRoute: AppRoutes.authCheck,
      getPages: [
        GetPage(
          name: AppRoutes.authCheck,
          page: () => const AuthCheckScreen(),
        ),
        GetPage(
          name: AppRoutes.register,
          page: () => RegistrationScreen(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => LoginScreen(),
        ),
        GetPage(
          name: AppRoutes.classDashboard,
          page: () => KelasPopulerScreenClean(),
        ),
        GetPage(
          name: AppRoutes.mainDashboard,
          page: () => MainScreenWithNavBar(),
        ),
      ],
    );
  }
}

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthCheckController());
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
