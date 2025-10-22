import 'package:flutter/material.dart';
import 'package:luarsekolah/utils/storage_helper.dart'; 
import 'package:luarsekolah/utils/storage_keys.dart';     
import 'package:luarsekolah/login_screen.dart';     
import 'package:luarsekolah/screens/profile_form_screen.dart';
import 'custom_field.dart'; 


const Color _kGreen = Color.fromRGBO(7, 126, 96, 1); 

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  
  Widget? _nextScreen; 

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final storage = await StorageHelper.getInstance();
    final isUserLoggedIn = storage.getBool(StorageKeys.rememberMe) ?? false;
    
    
    if (isUserLoggedIn) {
      _nextScreen = const MainScreenWithNavBar();
    } else {
     
      _nextScreen = LoginScreen();
    }

    await Future.delayed(const Duration(milliseconds: 1000)); 
    
    if (mounted) {
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




//final storage = await StorageHelper.getInstance();
//final isUserLoggedIn = storage.getBool(StorageKeys.rememberMe) ?? false;
//dengan menggunakan code itu bisa menyimpan, membaca, dan menghapus data di sana — dan data itu tetap tersimpan meski aplikasi ditutup.