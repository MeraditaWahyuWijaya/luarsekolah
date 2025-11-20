import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart'; 
import 'package:luarsekolah/data/providers/firebase_auth_service.dart'; // <<< Tambahkan Firebase Auth Service
import 'package:luarsekolah/presentation/views/register_screen.dart'; 
import 'package:luarsekolah/presentation/widgets/custom_field.dart'; 
import 'package:luarsekolah/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';// <<< Tambahkan import untuk navigasi
import '/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Ganti inisialisasi ApiService dengan FirebaseAuthService
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  bool _isLoading = false; 
  bool _isPasswordVisible = false;
  // reCAPTCHA hanya simulasi, pertahankan logikanya untuk UI
  bool _isRecaptchaVerified = false;

  // Validator yang diperbarui (Tidak wajib diubah, tapi rapihkan yang di bawah)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email wajib diisi';
    if (!value.contains('@')) return 'Masukkan email yang valid';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password wajib diisi';
    return null;
  }

  void _handleLogin() async {
    if (!_isRecaptchaVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap verifikasi reCAPTCHA')));
      return;
    }

    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // <<< BAGIAN UTAMA YANG BERUBAH: PANGGIL FIREBASE AUTH SERVICE
         final authController = Get.find<AuthController>();
        await authController.login(
        email: _emailController.text,
        password: _passwordController.text,
      );


        // Jika login berhasil, simpan email dan navigasi.
        await StorageHelper.saveLastEmail(_emailController.text);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil 🎉')),
        );

        // Navigasi ke MainScreenWithNavBar
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            settings: const RouteSettings(name: '/main'),
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) => const MainScreenWithNavBar(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const beginOffset = Offset(1.0, 0.0);
              const endOffset = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: beginOffset, end: endOffset).chain(CurveTween(curve: curve));
              var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(
                  opacity: animation.drive(fadeTween),
                  child: child,
                ),
              );
            },
          ),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        // Tangani Exception dari Firebase Auth Service
        String errorMessage = e.toString().replaceFirst('Exception: ', '');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Gagal: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadLastEmail();
  }

  void loadLastEmail() async {
    final lastEmail = await StorageHelper.getLastEmail();
    setState(() {
      _emailController.text = lastEmail ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
         key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              // Ganti Image.asset sesuai kebutuhan (asumsi asset ada)
              Image.asset('assets/luarsekolahlogo.png', height: 50), 
              const SizedBox(height: 12),
              Text(
                "Masuk ke Akun Luarsekolah dan Akses Materi dan Belajar Bekerja",
                style: GoogleFonts.montserrat(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Satu akun untuk akses Luarsekolah dan Belajar Bekerja",
                style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Aktif',
                  hintText: 'Masukkan email yang aktif',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty || !value.contains('@')
                        ? 'Masukkan email yang aktif'
                        : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password akunmu',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isRecaptchaVerified,
                      onChanged: (value) {
                        setState(() {
                          _isRecaptchaVerified = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "I'm not a robot",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    //Ganti Image.asset sesuai kebutuhan (asumsi asset ada)
                    Image.asset(
                    'assets/recaptcha.png',
                       height: 30,
                       width: 30,
                       fit: BoxFit.contain,
                     ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (_isRecaptchaVerified && !_isLoading) ? _handleLogin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(7, 126, 96, 1.0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Masuk',
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 220, 233, 255),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 23, 137, 230),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "Belum punya akun? Daftar sekarang",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 23, 137, 230),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}