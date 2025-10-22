import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_screen.dart';
import 'custom_field.dart';
import '../route.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, 
      
      initialRoute: AppRoutes.register, 
      onGenerateRoute: onAppGenerateRoute,
    );
  }
}