import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile_images_full_screen.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  String? _jobStatus;

  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('userName') ?? '';
      _dobController.text = prefs.getString('userDOB') ?? '';
      _addressController.text = prefs.getString('userAddress') ?? '';

      final genderFromPrefs = prefs.getString('userGender');
      _selectedGender = (genderFromPrefs == 'Laki-laki' || genderFromPrefs == 'Perempuan')
          ? genderFromPrefs
          : null;

      final jobFromPrefs = prefs.getString('userJobStatus');
      _jobStatus = (jobFromPrefs != null &&
          ["Pelajar", "Mahasiswa", "Karyawan", "Lainnya"].contains(jobFromPrefs))
          ? jobFromPrefs
          : null;
    });
    _checkFormFilled();
  }

  void _checkFormFilled() {
    setState(() {
      _isFormFilled = _nameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _selectedGender != null &&
          _jobStatus != null &&
          _addressController.text.isNotEmpty;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      await prefs.setString('userDOB', _dobController.text);
      await prefs.setString('userGender', _selectedGender ?? '');
      await prefs.setString('userJobStatus', _jobStatus ?? '');
      await prefs.setString('userAddress', _addressController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data berhasil disimpan!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            onChanged: _checkFormFilled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'profile-image-hero-tag',
                      child: ClipOval(
                        child: Image.asset(
                          'assets/nailong.jpg',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Semangat Belajarnya,",
                            style: GoogleFonts.montserrat(fontSize: 14)),
                        Text(_nameController.text.isEmpty
                            ? "Nama Kamu"
                            : _nameController.text),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  "Edit Profil",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileImageFullScreen(), 
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'profile-image-hero-tag',
                        child: ClipOval(
                          child: Image.asset(
                            'assets/nailong.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Upload foto baru dengan ukuran <1 MB,\ndan bertipe JPG atau PNG.",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8, 
                        
                        child: OutlinedButton.icon(
                          onPressed: () {
                          },
                          style: OutlinedButton.styleFrom(
                            
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.image),
                          label: Text(
                            "Upload Foto",
                            style: GoogleFonts.montserrat(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                

                const SizedBox(height: 20),
                Text("Data Diri",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _nameController,
                  label: "Nama Lengkap",
                  hint: "Masukkan nama lengkap",
                ),

                _buildTextField(
                  controller: _dobController,
                  label: "Tanggal Lahir",
                  hint: "Masukkan tanggal lahirmu",
                  icon: Icons.calendar_today,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      _dobController.text =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    }
                  },
                ),

                _buildDropdownField(
                  label: "Jenis Kelamin",
                  value: _selectedGender,
                  items: const ["Laki-laki", "Perempuan"],
                  onChanged: (val) {
                        setState(() => _selectedGender = val);
                    _checkFormFilled();
                  },
                ),

                _buildDropdownField(
                  label: "Status Pekerjaan",
                  value: _jobStatus,
                  items: const ["Pelajar", "Mahasiswa", "Karyawan", "Lainnya"],
                  onChanged: (val) {
                    setState(() => _jobStatus = val);
                    _checkFormFilled();
                  },
                ),

                _buildTextField(
                  controller: _addressController,
                  label: "Alamat Lengkap",
                  hint: "Masukkan alamat lengkap",
                  maxLines: 3,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isFormFilled ? _saveProfile : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormFilled ? Colors.green.shade700 : Colors.grey.shade300,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Simpan Perubahan",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        color: _isFormFilled ? Colors.white : Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.montserrat(fontSize: 14)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            readOnly: onTap != null,
            onTap: onTap,
            validator: (value) =>
                value!.isEmpty ? "Kolom ini wajib diisi" : null,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon) : null,
              hintStyle: GoogleFonts.montserrat(fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.montserrat(fontSize: 14)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.all(12),
            ),
            hint: Text("Pilih $label".toLowerCase(),
                style: GoogleFonts.montserrat(fontSize: 13)),
            items: items
                .map((item) =>
                    DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            validator: (val) => val == null ? "Pilih $label" : null,
          ),
        ],
      ),
    );
  }
}