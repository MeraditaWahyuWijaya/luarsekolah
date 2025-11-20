import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Import File Setup & Binding
import 'firebase_options.dart';
import 'package:luarsekolah/presentation/bindings/notification_binding.dart'; 
import 'package:luarsekolah/presentation/bindings/auth_binding.dart'; 
import 'package:luarsekolah/presentation/bindings/todo_binding.dart';
import 'package:luarsekolah/presentation/bindings/class_binding.dart'; 

// Import Views (Sesuaikan dengan nama view Anda yang sebenarnya)
import 'package:luarsekolah/presentation/views/coin_ls_screen.dart';
import 'package:luarsekolah/presentation/views/class_screen.dart';
import 'package:luarsekolah/presentation/views/login_screen.dart'; 
import 'package:luarsekolah/presentation/views/register_screen.dart'; 
import 'package:luarsekolah/presentation/views/todo_detail_page.dart';

// FCM BACKGROUND HANDLER
// Fungsi global untuk menangani pesan saat aplikasi ditutup (Terminated)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // PENTING Wajib inisialisasi Firebase lagi di handler background
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling Background Message: ${message.messageId}');
}


class AppRoutes {
  static const String register = '/register'; 
  static const String login = '/login'; 
  static const String todoDashboard = '/todo'; 
  static const String classDashboard = '/kelas'; 
  static const String todoDetail = '/todo_detail'; // Rute Deep Link
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Timezone Wajib untuk Local Notification Scheduling
  tz.initializeTimeZones();
  // Atur zona waktu lokal (Asia/Jakarta)
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); 

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); 
  
  // Daftarkan Background Handler FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
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
          page: () => const RegistrationScreen(), // Ganti dengan nama view Anda
          binding: AuthBinding(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => const LoginScreen(),
          binding: AuthBinding()
        ),
        
        // Rute Utama To-Do yang Memasang MainBinding (Notifikasi)
        GetPage(
          name: AppRoutes.todoDashboard,
          page: () => const TodoDashboardPage(), // Ganti dengan nama view Anda
          binding: MainBinding(), // MainBinding di sini
        ),
        
        // Rute Deep Link untuk Notifikasi
        GetPage(
          name: AppRoutes.todoDetail,
          page: () => const TodoDetailPage(), // Ganti dengan nama view Detail Anda
          binding: MainBinding(), // MainBinding di sini
        ),

        // Rute Lainnya
        GetPage(
        name: AppRoutes.classDashboard, 
        page: () => KelasPopulerScreenClean(), // Ganti dengan nama view Anda
        binding: ClassBinding(),
      ),
      ],
    );
  }
}