import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart'; 
import 'package:luarsekolah/presentation/routes/route.dart';
import 'package:luarsekolah/data/providers/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final ApiService _apiService = ApiService(); //ini api nya // ambil data api_Service.dart
  bool _isLoading = false; //kenapa false, karena nanti akan berubah jadi true ketika api jalan dan kemblai false lagi

  String? _recaptchaToken;
  bool _isRecaptchaVerified = false;

  int _currentPageIndex = 0;
  String _registeredEmail = '';

  bool _isPasswordVisible = false;
  bool isFormValid = false;

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumberOrSymbol = false;

  bool waValidFormat = false;
  bool waMinLength = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => _validateWhatsApp(_phoneController.text));
    _passwordController.addListener(_validatePassword);
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    bool isPhoneAllValid = waValidFormat && waMinLength;
    bool isPasswordAllValid = hasMinLength && hasUppercase && hasNumberOrSymbol;

    setState(() {
      isFormValid =
          _isRecaptchaVerified &&
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          isPhoneAllValid &&
          isPasswordAllValid;
    });
  }


  void _validateWhatsApp(String value) {
    setState(() {
      waValidFormat = value.startsWith('62');
      waMinLength = value.length >= 10;
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      hasMinLength = password.length >= 8;
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasNumberOrSymbol =
          password.contains(RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]'));
    });
  }

  void _handleRegistration(BuildContext context) async {
    if (_formKey.currentState!.validate() && _isRecaptchaVerified) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _apiService.signUp(  //API //aplikasi akan menunggu hingga proses pengiriman data (_apiService.signUp)
        // selesai sebelum melanjutkan ke baris kode
          name: _nameController.text, //data yg dikirim ke srver yg udh diisi user
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
        );

        await StorageHelper.saveLastEmail(_emailController.text);

        setState(() {
          _registeredEmail = _emailController.text;
          _currentPageIndex = 1; 
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi Gagal: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
       if (!_isRecaptchaVerified) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Harap verifikasi reCAPTCHA')),
         );
       }
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }


  Widget _buildValidationItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
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
                  text: _registeredEmail, 
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

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _navigateToLogin, 
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


  Widget _buildRegistrationFields(bool isPhoneAllValid, bool isPasswordAllValid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 3),
        Image.asset('assets/luarsekolahlogo.png', height: 40),
        const SizedBox(height: 10),
        Text("Daftarkan Akun Untuk Lanjut Akses ke Luarsekolah",
            style: GoogleFonts.montserrat(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Satu akun untuk akses Luarsekolah dan Belajar Bekerja",
            style: GoogleFonts.montserrat(
                fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
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
                Image.asset('assets/google.png', height: 18, width: 18),
                const SizedBox(width: 5),
                Text("Daftarkan dengan Google",
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        
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

        TextFormField(
            controller: _nameController,
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
                    isPhoneAllValid ? Icons.check_circle : Icons.cancel,
                    color: isPhoneAllValid ? Colors.green : Colors.red,
                  ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Nomor HP wajib diisi';
            if (!waValidFormat) return 'Nomor harus diawali 62';
            if (!waMinLength) return 'Nomor minimal 10 digit';
            return null;
          },
        ),
        const SizedBox(height: 8),

        _buildValidationItem('Format nomor diawali 62', waValidFormat),
        _buildValidationItem('Minimal 10 angka', waMinLength),

        const SizedBox(height: 20),

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
                if (_passwordController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      isPasswordAllValid ? Icons.check_circle : Icons.cancel,
                      color: isPasswordAllValid ? Colors.green : Colors.red,
                    ),
                  ),
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
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password wajib diisi';
            if (!isPasswordAllValid) return 'Password belum memenuhi semua kriteria.';
            return null;
          },
        ),
        const SizedBox(height: 8),

        _buildValidationItem('Minimal 8 karakter', hasMinLength),
        _buildValidationItem('Terdapat 1 huruf kapital', hasUppercase),
        _buildValidationItem('Terdapat 1 angka atau simbol', hasNumberOrSymbol),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                    _recaptchaToken = _isRecaptchaVerified ? 'dummy-token' : null;
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
                'assets/recaptcha.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        const SizedBox(height: 45),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (isFormValid && !_isLoading) ? () => _handleRegistration(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isFormValid && !_isLoading
                  ? const Color.fromRGBO(7, 126, 96, 1.0)
                  : Colors.grey,
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
                    child: CircularProgressIndicator( //tugas week05 loading
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
                  color: Color.fromARGB(255, 102, 178, 255), 
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

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
                  Image.asset('assets/havinghand.png', height: 20, width: 20),
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

  @override
  Widget build(BuildContext context) {
    bool isPhoneAllValid = waValidFormat && waMinLength;
    bool isPasswordAllValid = hasMinLength && hasUppercase && hasNumberOrSymbol;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                scale: animation, 
                child: child,);
              },
              child: Container(
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