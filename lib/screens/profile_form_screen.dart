import 'package:flutter/material.dart';
import 'package:luarsekolah/utils/validators.dart';
import 'package:luarsekolah/utils/storage_helper.dart';
import 'package:luarsekolah/utils/storage_keys.dart'; 
import 'package:luarsekolah/home_screen.dart'; 

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  // Logic yang Sudah Ada
  final _formKey = GlobalKey<FormState>();
  late StorageHelper _storage;
  bool _isStorageInitialized = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Variabel baru untuk menampung data form baru (misal: Tanggal Lahir, Gender)
  String? _selectedGender;
  String? _selectedJobStatus;
  String? _selectedDateOfBirth;
  final _addressController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _initStorageAndLoadData();
  }

  Future<void> _initStorageAndLoadData() async {
    _storage = await StorageHelper.getInstance();
    
    final rememberMe = _storage.getBool(StorageKeys.rememberMe); 
    if (rememberMe) {
      _emailController.text = _storage.getString(StorageKeys.userEmail);
      _nameController.text = _storage.getString(StorageKeys.userName);
      _phoneController.text = _storage.getString(StorageKeys.userPhone);
      setState(() {
        _rememberMe = true;
      });
    }

    setState(() {
      _isStorageInitialized = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // --- LOGIC FORM ---

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_rememberMe) {
        await _storage.saveUserData(
          email: _emailController.text,
          name: _nameController.text,
          phone: _phoneController.text,
        );
        await _storage.saveBool(StorageKeys.rememberMe, true);
      } else {
        await _storage.saveBool(StorageKeys.rememberMe, false);
        await _storage.removeMultiple([ 
          StorageKeys.userEmail, 
          StorageKeys.userName,
          StorageKeys.userPhone,
        ]);
      }
      
      await Future.delayed(const Duration(seconds: 1)); 

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      // Navigasi ke HomeScreen (Contoh, bisa diganti ke ProfileScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.onUserInteraction;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors.')),
      );
    }
  }

  Future<void> _clearFormAndStorage() async {
    // Logika Clear
    setState(() { _isLoading = true; });
    await _storage.removeMultiple([
      StorageKeys.rememberMe, StorageKeys.userEmail,
      StorageKeys.userName, StorageKeys.userPhone,
    ]);
    
    _formKey.currentState?.reset();
    _emailController.clear(); _passwordController.clear();
    _nameController.clear(); _phoneController.clear();
    _addressController.clear();

    setState(() {
      _rememberMe = false;
      _autoValidateMode = AutovalidateMode.disabled;
      _isLoading = false;
      _selectedGender = null;
      _selectedJobStatus = null;
      _selectedDateOfBirth = null;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form and saved data cleared!')),
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(7, 126, 96, 1), // Warna header datepicker
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // --- BAGIAN UI: SESUAI LAYOUT GAMBAR ---

  @override
  Widget build(BuildContext context) {
    if (!_isStorageInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: const Color.fromRGBO(7, 126, 96, 1),
          ),
        ),
      );
    }
    
    return Scaffold(
      // AppBar tidak digunakan karena layout dimulai dari header sapaan
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER SAPAAN & TOMBOL NAVIGASI
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile_photo.jpg'), // Ganti dengan logika foto Anda
                ),
                title: const Text('Semangat Belajarnya,', style: TextStyle(fontSize: 14)),
                subtitle: Text(
                  _nameController.text.isNotEmpty ? _nameController.text : 'Ahmad Sahroni',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.menu_book, color: Colors.black87),
                  label: const Text('Buka Navigasi Menu', style: TextStyle(color: Colors.black87)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.black54, width: 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // 2. EDIT PROFIL & UPLOAD FOTO
              const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/profile_photo.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red, 
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2))
                            ),
                            child: const Icon(
                              Icons.close, 
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    const Text(
                      'Upload foto baru dengan ukuran < 1 MB, dan bertipe JPG atau PNG.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.cloud_upload_outlined, color: Colors.black),
                        label: const Text('Upload Foto', style: TextStyle(color: Colors.black)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.black54),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // 3. DATA DIRI (FORM INPUT)
              const Text('Data Diri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // ** Nama Lengkap **
              const Text('Nama Lengkap', style: TextStyle(fontSize: 14, color: Colors.black87)),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Ahmad Sahroni',
                  border: UnderlineInputBorder(), 
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                ),
                validator: Validators.required('Nama Lengkap'),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),

              // ** Tanggal Lahir **
              const Text('Tanggal Lahir', style: TextStyle(fontSize: 14, color: Colors.black87)),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDateOfBirth ?? 'Masukkan tanggal lahirmu', 
                        style: TextStyle(color: _selectedDateOfBirth == null ? Colors.grey[600] : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ** Jenis Kelamin **
              const Text('Jenis Kelamin', style: TextStyle(fontSize: 14, color: Colors.black87)),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                ),
                hint: const Text('Pilih laki-laki atau perempuan'),
                items: ['Laki-laki', 'Perempuan']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // ** Status Pekerjaan **
              const Text('Status Pekerjaan', style: TextStyle(fontSize: 14, color: Colors.black87)),
              DropdownButtonFormField<String>(
                value: _selectedJobStatus,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                ),
                hint: const Text('Pilih status pekerjaanmu'),
                items: ['Pelajar', 'Mahasiswa', 'Pekerja']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJobStatus = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // ** Alamat Lengkap **
              const Text('Alamat Lengkap', style: TextStyle(fontSize: 14, color: Colors.black87)),
              TextFormField(
                controller: _addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(12),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade400)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 32),

              // ** Tombol Simpan Perubahan **
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(7, 126, 96, 1), 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0, 
                  ),
                  child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)) 
                      : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              
              // Tombol Clear dihilangkan/dipindahkan karena tidak ada di gambar
              // const SizedBox(height: 20),
              // TextButton(onPressed: _isLoading ? null : _clearFormAndStorage, child: const Text('Clear Saved Data (Logout)')),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar Sesuai Gambar
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, 
          selectedItemColor: const Color.fromRGBO(7, 126, 96, 1),
          unselectedItemColor: Colors.grey,
          currentIndex: 3, // Asumsi 'Akun' adalah index 3 jika hanya ada 4 tab
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'Kelasku'),
            BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'koinLS'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
          ],
          onTap: (index) {
            // Logika navigasi antar tab
          },
        ),
    );
  }
}