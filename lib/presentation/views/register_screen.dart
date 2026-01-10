import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart'; 
//Layanan untuk menangani panggilan API ke backend
import 'package:luarsekolah/data/providers/firebase_auth_service.dart';
import 'package:luarsekolah/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/main.dart';


//week09 pertama-tama bikin ui untuk user masukin email sm password

//Widget Utama
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //  Controller untuk Input Formulir 
 final _registrationFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Instance untuk penanganan panggilan API (asumsi ApiService sudah diimplementasikan)
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // Status untuk menampilkan indikator loading saat registrasi

  // Status reCAPTCHA 
  String? _recaptchaToken;
  bool _isRecaptchaVerified = false;

  // State Navigasi 
  // Mengatur tampilan: 0 untuk formulir registrasi, 1 untuk pesan verifikasi sukses
  int _currentPageIndex = 0;
  String _registeredEmail = ''; // Menyimpan email yang baru didaftarkan

  // Status Tampilan & Validasi Real-time 
  bool _isPasswordVisible = false; // Mengontrol visibilitas password
  bool isFormValid = false; // Status keseluruhan formulir (untuk mengaktifkan tombol Daftar)

  // Kriteria validasi kompleks untuk Password
  bool hasMinLength = false; // Minimal 8 karakter
  bool hasUppercase = false; // Minimal 1 huruf kapital
  bool hasNumberOrSymbol = false; // Minimal 1 angka atau simbol

  // Kriteria validasi kompleks untuk Nomor Telepon (WhatsApp)
  bool waValidFormat = false; // Harus dimulai dengan '62'
  bool waMinLength = false; // Minimal 10 digit

  @override
  void initState() {
    super.initState();
    // Menambahkan listener untuk memicu validasi real-time setiap kali input berubah
    _phoneController.addListener(() => _validateWhatsApp(_phoneController.text));
    _passwordController.addListener(_validatePassword);
    
    // Listener untuk memperbarui status tombol Daftar berdasarkan semua input
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // Memastikan controller dibuang (dispose) untuk menghindari kebocoran memori
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // --- Fungsi Kompleks: Pembaruan Status Tombol Daftar ---
  // Fungsi ini dipanggil setiap kali ada perubahan pada input untuk menentukan
  // apakah tombol registrasi harus diaktifkan atau dinonaktifkan.
  void _updateButtonState() {
    // 1. Cek semua kriteria validasi telepon dan password
    bool isPhoneAllValid = waValidFormat && waMinLength;
    bool isPasswordAllValid = hasMinLength && hasUppercase && hasNumberOrSymbol;

    setState(() {
      // 2. Gabungkan semua kondisi:
      //    - reCAPTCHA terverifikasi
      //    - Semua kolom wajib diisi (tidak kosong)
      //    - Email mengandung karakter '@'
      //    - Semua kriteria validasi telepon terpenuhi
      //    - Semua kriteria validasi password terpenuhi
      isFormValid =
          _isRecaptchaVerified &&
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          isPhoneAllValid &&
          isPasswordAllValid;
    });
  }


  // --- Fungsi Validasi Real-time: Nomor WhatsApp ---
  void _validateWhatsApp(String value) {
    setState(() {
      waValidFormat = value.startsWith('62');
      waMinLength = value.length >= 10;
    });
    _updateButtonState(); // Panggil pembaruan status tombol setelah validasi
  }

  // --- Fungsi Validasi Real-time: Password ---
  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      hasMinLength = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      // Regex untuk memeriksa keberadaan angka ATAU simbol
      hasNumberOrSymbol =
          password.contains(RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]'));
    });
    _updateButtonState(); // Panggil pembaruan status tombol setelah validasi
  }

  // --- Fungsi Kompleks: Penanganan Registrasi (API Call) ---
  void _handleRegistration(BuildContext context) async {
    // 1. Validasi Formulir Global dan reCAPTCHA
    if (_registrationFormKey.currentState!.validate() && _isRecaptchaVerified) {
      setState(() {
        _isLoading = true; // Aktifkan indikator loading
      });

      try {
        // 2. Panggilan ke Layanan API
         final authController = Get.find<AuthController>();
      await authController.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
    );


        // 3. Sukses: Simpan email dan pindah ke layar verifikasi
        // Simpan email agar bisa diisi otomatis di halaman login
        await StorageHelper.saveLastEmail(_emailController.text);

        setState(() {
          _registeredEmail = _emailController.text;
          _currentPageIndex = 1; // Beralih ke tampilan pesan verifikasi
        });

      } catch (e) {
        // 4. Gagal: Tampilkan SnackBar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi Gagal: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      } 
      finally {
        // 5. Akhiri loading, terlepas dari hasil sukses atau gagal
        setState(() {
          _isLoading = false;
        });
      }
    } else {
        // Penanganan error jika tombol ditekan tanpa reCAPTCHA terverifikasi
        if (!_isRecaptchaVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Harap verifikasi reCAPTCHA')),
          );
        }
    }
  }

  // Fungsi navigasi sederhana ke halaman login
  void _navigateToLogin() {
    // Menggunakan pushReplacementNamed agar pengguna tidak bisa kembali ke halaman registrasi
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  //Komponen UI: Indikator Validasi
  // Membangun elemen UI untuk menunjukkan status validasi password/telepon
  Widget _buildValidationItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            // Ganti ikon berdasarkan status validitas
            isValid ? Icons.check_circle : Icons.check_circle_outline,
            color: isValid ? Colors.green.shade700 : Colors.grey.shade400,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: isValid ? Colors.black : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- Komponen UI: Tampilan Verifikasi Sukses (Index 1) ---
  Widget _buildVerificationForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Icon(
          Icons.email,
          size: 80, 
          color: Theme.of(context).primaryColor, 
        ),
        const SizedBox(height: 30),

        const Text(
          "Email Verifikasi Sudah Dikirim ke Emailmu",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),

        // Detail instruksi verifikasi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w300, 
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Silakan cek kotak masuk di email ',
                ),
                TextSpan(
                  text: _registeredEmail, // Tampilkan email yang didaftarkan
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' untuk melakukan verifikasi akunmu. Jika kamu tidak menerima pesan di kotak masukmu, coba untuk cek di folder spam atau ',
                ),
                TextSpan(
                  text: 'kirim ulang verifikasi',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Tombol untuk navigasi ke halaman login
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _navigateToLogin, // Panggil fungsi navigasi
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(), 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5), 
              foregroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Akses Halaman Masuk",
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  //  Komponen UI: Formulir Registrasi Utama (Index 0)
  Widget _buildRegistrationFields(bool isPhoneAllValid, bool isPasswordAllValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        const SizedBox(height: 3),
        // Logo
        Image.asset('assets/luarsekolahlogo.png', height: 40), 
        Text("Daftarkan Akun Untuk Lanjut Akses ke Luarsekolah",
            style: GoogleFonts.montserrat(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Satu akun untuk akses Luarsekolah dan Belajar Bekerja",
            style: GoogleFonts.montserrat(
                fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),

        // Tombol Daftar dengan Google (Placeholder)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () { /* TODO: Implementasi Pendaftaran dengan Google */ },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade400, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/google.png', height: 18, width: 18), // Asumsi: 'assets/google.png' tersedia
                const SizedBox(width: 5),
                Text("Daftarkan dengan Google",
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Pembatas
        Row(
          children: [
            const Expanded(
                child: Divider(color: Colors.grey, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("atau gunakan email",
                  style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            const Expanded(
                child: Divider(color: Colors.grey, thickness: 1)),
          ],
        ),
        const SizedBox(height: 20),

        // Kolom Input: Nama Lengkap
        TextFormField(
            controller: _nameController, //views manggil fungsi controller
          decoration: InputDecoration(
            labelText: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkapmu',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Nama wajib diisi' : null,
        ),
        const SizedBox(height: 20),

        // Kolom Input: Email Aktif
        TextFormField(
            controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Aktif',
            hintText: 'Masukkan email yang aktif',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          validator: (value) =>
              value == null || value.isEmpty || !value.contains('@')
                  ? 'Masukkan email yang valid'
                  : null,
        ),
        const SizedBox(height: 20),

        // Kolom Input: Nomor Whatsapp Aktif
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Nomor Whatsapp Aktif',
            hintText: 'Masukkan nomor whatsapp yang bisa dihubungi',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            suffixIcon: _phoneController.text.isEmpty
                ? null
                : Icon(
                    // Ikon berubah berdasarkan status validasi gabungan
                    isPhoneAllValid ? Icons.check_circle : Icons.cancel,
                    color: isPhoneAllValid ? Colors.green : Colors.red,
                  ),
          ),
          // Validator utama (hanya dipanggil saat tombol Daftar ditekan)
          validator: (value) {
            if (value == null || value.isEmpty) return 'Nomor HP wajib diisi';
            if (!waValidFormat) return 'Nomor harus diawali 62';
            if (!waMinLength) return 'Nomor minimal 10 digit';
            return null;
          },
        ),
        const SizedBox(height: 8),

        // Indikator Validasi Nomor Telepon
        _buildValidationItem('Format nomor diawali 62', waValidFormat),
        _buildValidationItem('Minimal 10 angka', waMinLength),

        const SizedBox(height: 20),

        // Kolom Input: Password
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Masukkan Password untuk akunmu',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon status validasi gabungan password
                if (_passwordController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      isPasswordAllValid ? Icons.check_circle : Icons.cancel,
                      color: isPasswordAllValid ? Colors.green : Colors.red,
                    ),
                  ),
                // Tombol toggle visibilitas password
                IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ],
            ),
          ),
          // Validator utama (hanya dipanggil saat tombol Daftar ditekan)
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password wajib diisi';
            if (!isPasswordAllValid) return 'Password belum memenuhi semua kriteria.';
            return null;
          },
        ),
        const SizedBox(height: 8),

        // Indikator Validasi Password
        _buildValidationItem('Minimal 8 karakter', hasMinLength),
        _buildValidationItem('Terdapat 1 huruf kapital', hasUppercase),
        _buildValidationItem('Terdapat 1 angka atau simbol', hasNumberOrSymbol),

        const SizedBox(height: 20),

        // reCAPTCHA Placeholder (Simulasi)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade50,
          ),
          child: Row(
            children: [
              // Checkbox untuk simulasi verifikasi reCAPTCHA
              Checkbox(
                value: _isRecaptchaVerified,
                onChanged: (value) {
                  setState(() {
                    _isRecaptchaVerified = value ?? false;
                    _recaptchaToken = _isRecaptchaVerified ? 'dummy-token' : null; // Token dummy
                  });
                  _updateButtonState();
                },
              ),

              Expanded(
                child: Text(
                  "I'm not a robot",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _isRecaptchaVerified ? Colors.black : Colors.black87,
                  ),
                ),
              ),

              Image.asset(
                'assets/recaptcha.png', // Asumsi: 'assets/recaptcha.png' tersedia
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        const SizedBox(height: 45),

        // --- Tombol Registrasi Utama ---
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            // Tombol hanya aktif jika isFormValid TRUE dan tidak sedang loading
            onPressed: (isFormValid && !_isLoading) ? () => _handleRegistration(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFormValid && !_isLoading
                  ? const Color.fromRGBO(7, 126, 96, 1.0) // Warna Hijau Utama
                  : Colors.grey, // Warna abu-abu saat dinonaktifkan
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator( // Indikator loading
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    'Daftarkan Akun',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Syarat dan Ketentuan
        RichText(
          text: TextSpan(
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey, 
            ),
            children: [
              const TextSpan(text: "Dengan mendaftar di Luarsekolah, kamu menyetujui "),
              TextSpan(
                text: "syarat dan ketentuan kami",
                style: const TextStyle(
                  color: Color.fromARGB(255, 102, 178, 255), // Warna tautan biru
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tautan ke Halaman Masuk (Login)
        Center(
          child: InkWell( 
            onTap: () { 
              Navigator.pushNamed( 
                context, 
                AppRoutes.login,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 233, 255),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 23, 137, 230),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/havinghand.png', height: 20, width: 20), // Asumsi: 'assets/havinghand.png' tersedia
                  const SizedBox(width: 5),
                  Text(
                    "Sudah punya akun? Masuk ke akunmu",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 23, 137, 230),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // --- Fungsi Build Utama ---
  @override
  Widget build(BuildContext context) {
    // Hitung ulang status validasi (walaupun sudah dilakukan di _updateButtonState, ini untuk passing parameter)
    bool isPhoneAllValid = waValidFormat && waMinLength;
    bool isPasswordAllValid = hasMinLength && hasUppercase && hasNumberOrSymbol;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _registrationFormKey,
            // AnimatedSwitcher digunakan untuk transisi halus antara formulir registrasi dan pesan verifikasi sukses
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Menggunakan transisi Scale (perubahan ukuran)
                return ScaleTransition(
                scale: animation, 
                child: child,);
              },
              child: Container(
                // Key harus unik untuk setiap child agar AnimatedSwitcher tahu kapan harus melakukan transisi
                key: ValueKey<int>(_currentPageIndex), 
                child: _currentPageIndex == 0
                    ? _buildRegistrationFields(isPhoneAllValid, isPasswordAllValid)
                    : _buildVerificationForm(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}