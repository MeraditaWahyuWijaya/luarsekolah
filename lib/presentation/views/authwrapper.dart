import 'package:flutter/material.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart'; 
import 'package:luarsekolah/data/providers/storage_keys.dart';     
import 'package:luarsekolah/presentation/views/login_screen.dart';     
import 'package:luarsekolah/presentation/widgets/custom_field.dart'; 

// Menentukan apakah pengguna dialihkan ke LoginScreen atau MainScreenWithNavBar.
const Color _kGreen = Color.fromRGBO(7, 126, 96, 1); 

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  
  Widget? _nextScreen; // Variabel untuk menyimpan widget layar berikutnya (Login atau Main).

  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); // Memulai pengecekan status autentikasi segera setelah widget dibuat.
  }

  Future<void> _checkAuthStatus() async {
    final storage = await StorageHelper.getInstance();// 1. Akses penyimpanan lokal (Shared Preferences)
    final isUserLoggedIn = storage.getBool(StorageKeys.rememberMe) ?? false; // 2. Periksa status 'Ingat Saya' yang disimpan secara lokal.
    
    
    if (isUserLoggedIn) { // Jika 'rememberMe' true, alihkan ke layar utama.
      _nextScreen = const MainScreenWithNavBar();
    } else {
     
      _nextScreen = LoginScreen(); // Jika 'rememberMe' false/null, alihkan ke layar login.
    }

    await Future.delayed(const Duration(milliseconds: 1000)); // Jeda 1 detik untuk memberikan efek splash screen atau waktu loading.
    
    if (mounted) { // Perbarui UI hanya jika widget masih aktif (mounted).
      setState(() {}); 
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_nextScreen == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: _kGreen),
        ),
      );
    }
    
    return _nextScreen!;
  }
}



