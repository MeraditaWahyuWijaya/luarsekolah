import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; 
import 'custom_field.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget { //kenapa pakainya statefull? 
  const RegistrationScreen({super.key}); 
//karena, 
// 1. Ada interaksi user (button click, text input)
// 2. Data berubah seiring waktu (timer, animation)
// 3. Async operations (API calls, database)
// 4. Form handling dan validation
// 5. Dynamic UI updates

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> { //Halaman untuk menyimpan data 
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
String? _validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Nama wajib diisi';
  }
  return null;
}

String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email wajib diisi';
  }
  if (!value.contains('@')) {
    return 'Masukkan email yang valid';
  }
  return null;
}

String? _validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Nomor WhatsApp wajib diisi';
  }
  if (!value.startsWith('62')) {
    return 'Nomor harus diawali 62';
  }
  if (value.length < 10) {
    return 'Nomor minimal 10 digit';
  }
  return null;
}

late final List<Map<String, dynamic>> registrationFields = [
  {
    'label': 'Nama Lengkap',
    'controller': _nameController, // Controller unik
    'keyboardType': TextInputType.text,
    'isPassword': false,
    'validator': _validateName, // Fungsi validasi
  },
  {
    'label': 'Email',
    'controller': _emailController,
    'keyboardType': TextInputType.emailAddress,
    'isPassword': false,
    'validator': _validateEmail,
  },
  {
    'label': 'Nomor WhatsApp',
    'controller': _phoneController,
    'keyboardType': TextInputType.phone,
    'isPassword': false,
    'validator': _validatePhone, // Contoh: validator untuk Phone
  },
  {
    'label': 'Password',
    'controller': _passwordController,
    'keyboardType': TextInputType.text,
    'isPassword': true,
    'validator': _validatePassword, // Contoh: validator untuk Password
  },
];
  String? _recaptchaToken;
  bool _isRecaptchaVerified = false;
  
  // State untuk mengontrol tampilan layar (Form atau Verifikasi) 
  bool _isRegistered = false; //bool itu dari kata boolean yang berarti menyimpan data bernilai benar/salah 

  // Variabel State
  bool _isPasswordVisible = false;
  bool isFormValid = false;

  // State untuk Validasi Password
  bool hasMinLength = false; // untuk validasi di password agar sesuai ketentuan yaa, 
  bool hasUppercase = false;  //minimal 8 karakter, harus ada huruf kapital, harus ada angka atau simbol
  bool hasNumberOrSymbol = false;

  // State untuk Validasi WA   //ini untuk validasi yang ada di wa sama kayak password
  bool waValidFormat = false; // ini formatnya harus 62 didepannya
  bool waMinLength = false; // ini formatnya harus min 10 angka 

//HALAMAN UNTUK MENENTUKAN NILAI BENAR/SALAH , jadi bool disini itu untuk menentukan benar/salahnya nilai . 

  void _updateButtonState() {  //Fungsi void disini itu untuk tombol daftar akun nantinya bisa nyala/dipencet, jadi kayak semacam syarat yang harus terpenuhi gitu
    setState(() {  //ini perintah kepada buttonnya 
      isFormValid =  //form ini valid jikaaa??
      _isRecaptchaVerified &&  // anda bukan robot?
      _nameController.text.isNotEmpty && //nama tidak kosong
      _emailController.text.isNotEmpty && //email tikdak kosong
        _emailController.text.contains('@') && //email harus pakai "@"
      waValidFormat && // nomor wa dengan format yg valid yaitu 62
      waMinLength && // nomor wa dengan format min 10 angka yang dimasukkan 
      hasMinLength && // password min format 8 karakter ?
      hasUppercase && // password ada huruf kapital ?
      hasNumberOrSymbol; // password punya angka dan simbol ?
    });  // nah setelah ini semua sudah terverifikasi valid/ benar maka tombol baru bisa dipencet/muncul 
  }

  @override
  void initState() { //perintah yang dipanggil saat layar muncul 
    super.initState(); //perintah untuk menyiapka/ cek 
    _phoneController.addListener(() => _validateWhatsApp(_phoneController.text)); // jadi setiap kita mengetik itu, agar bisa ngecek bener atau tidaknya
    _passwordController.addListener(_validatePassword);                           //misal kayak di password itu kan kita ga nulis huruf kapital langsung 
    _nameController.addListener(_updateButtonState);                              // terdeteksi gabisa, nah itu pakai ini.
    _emailController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  } // Add listener untuk password strength check

  @override //halaman ini adalah untuk bersih bersih memori yang tadi digunakan oleh controller 
  void dispose() {  //Jika Controller tidak dipanggil .dispose()--
    _phoneController.dispose(); //meskipun layarnya sudah ditutup, mereka akan tetap "hidup" di memori aplikasi.
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose(); // nah ada juga namanya super.dispose();: Ini adalah langkah terakhir, 
  }                   //yaitu bilang ke Flutter: "Sudah beres bersih-bersih di bagianku, sekarang lakukan juga proses bersih-bersih standar yang lain."

  void _validateWhatsApp(String value) { // ini adalah validasi wa 
    setState(() {
      waValidFormat = value.startsWith('62'); //NILAINYA HARUS DIAWALI 62
      waMinLength = value.length >= 10; //MIN PANJANGANYA 10 ANGKA 
    });
  }

  void _validatePassword() { //VALIDASI PASSWORD SAMA KAYAK ATAS YAAA
    final password = _passwordController.text;
    setState(() {
      hasMinLength = password.length >= 8; 
      hasUppercase = password.contains(RegExp(r'[A-Z]'));
      hasNumberOrSymbol =
          password.contains(RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]'));
    });
  }
  
  // PENGGANTI NAV PUSH
  //Intinya: Fungsi ini adalah pemrosesan akhir pendaftaran. 
  //Ia memastikan data valid, mencatat keberhasilan pendaftaran okkk
  void _handleRegistrationSuccess() {
    if (_formKey.currentState!.validate()) { //ini buat memeriksa ulang formulir kayak bilang apakah uda yakin semua syarat terpenuhi?
      // Simulasi proses pendaftaran berhasil
      setState(() {
        _isRegistered = true; // Buat Beralih ke layar verifikasi , nah kalau nilainya benar nantiinya bakal dialihkan ke tampilan selanjutnya 
      });
      // Opsional: Sembunyikan keyboard
      FocusScope.of(context).unfocus(); 
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); //menghilangkan snackbar 
    }
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

  // WIDGET BARU NTAR HABIS DI VERIFIKASI EMAIL
  Widget _buildEmailVerificationScreen(String email) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),//atur jarak email
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/email.png', width: 100), 

          Text(
            'Email Verifikasi Sudah Dikirim ke Emailmu',
            style: GoogleFonts.montserrat(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          RichText( //PAKAI RICHTEXT UNTUK GABUNGIN TEXT DAN WIDGET?
            text: TextSpan( //textspan itu untuk merubah gaya dari text, misal tebel/engga , ukurannya beda dll
              style: GoogleFonts.montserrat( //font yang dipake
                  fontSize: 16, color: Colors.black87, height: 1.5),
              children: [
                const TextSpan(
                  text: 'Silakan cek kotak masuk di email ',
                ),
                TextSpan(
                  text: email, // Email pengguna
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' untuk melakukan verifikasi akunmu. Jika kamu tidak menerima pesan di kotak masukmu, coba untuk cek di folder spam atau ',
                ),
                WidgetSpan( // sama kayak textspan cuman bedanya ini widget, mungkin didalemnya bisa berisi icon,button 
                  child: InkWell( //respon sentuhan 
                    onTap: () { //karna yang dipilih ontap berarti nanti akan dipanggil saat mengetuk/klik 
                      // Ini buat kirim ulang kode verif
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mengirim ulang verifikasi...'))); //klik yang dimaksut klik ini
                    },
                    child: Text(
                      'kirim ulang verifikasi',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          TextButton.icon( //TEXT YANG BISA JADI BUTTON YANG BISA DIKLIK 
            onPressed: () {  //JIKA DIPRESS LANGSUNG KE HALAMAN VERIF
               Navigator.pushReplacement( 
                context,
                MaterialPageRoute(
                  // Pindah ke HomeScreen
                  builder: (context) => const HomeScreen(),
                ),
              );
              // TODO: Navigasi ke halaman Login utama
              // Anda bisa menggunakan Navigator.pop() untuk kembali ke halaman sebelumnya
              // atau menavigasi ke rute login utama.
              print('Akses halaman masuk diklik. Navigasi ke Home.');
            },
            icon: const Icon(Icons.open_in_new),
            label: Text(
              'Akses halaman masuk',
              style: GoogleFonts.montserrat(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    bool isPhoneAllValid = waValidFormat && waMinLength;
    bool isPasswordAllValid = hasMinLength && hasUppercase && hasNumberOrSymbol;

    return Scaffold(
      body: SingleChildScrollView(
        // ADA 2 SCREEN NANTINYA
        child: _isRegistered 
            ? _buildEmailVerificationScreen(_emailController.text) // Tampilkan Layar Verifikasi
            : Padding( 
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30), //untuk mengatur height dari atas asset logo luar sekolah
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

                      // Tombol Google
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey.shade400, width: 1),// Garis tepi outline
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

                      // Nama
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

                      // Email
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

                      // Nomor WA
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

                      // Password
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
                            children: [ //UNTUK CHECK BENAR SALAH PASSWORD , KALAU BENAR GREEN , SALAH RED
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

                      // reCAPTCHA Checkbox
                      Container( //RECAPTCHA PAKAI CONTAINER YA
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

                      // Tombol Daftar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isFormValid
                              ? _handleRegistrationSuccess // < PANGGIL FUNGSI BERALIH STATE
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFormValid ? const Color.fromRGBO(7, 126, 96, 1.0) : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: Text('Daftarkan Akun',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Teks Syarat dan Ketentuan
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey, // default color untuk teks lain
                          ),
                          children: [
                            const TextSpan(text: "Dengan mendaftar di Luarsekolah, kamu menyetujui "),
                            TextSpan(
                              text: "syarat dan ketentuan kami",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 102, 178, 255), // biru muda
                              ),
                            ),
                          ],
                        ),
                      ),


                      const SizedBox(height: 24),

                      // Tombol "Sudah punya akun? Masuk ke akunmu"
                     Center(
  child: InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    },
    borderRadius: BorderRadius.circular(8),
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
                  ),
                ),
              ),
      ),
    );
  }
}
