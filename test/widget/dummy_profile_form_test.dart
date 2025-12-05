import 'package:flutter/material.dart';

class ProfileFormDummy extends StatefulWidget {
  const ProfileFormDummy({super.key});

  @override
  State<ProfileFormDummy> createState() => _ProfileFormDummyState();
}

class _ProfileFormDummyState extends State<ProfileFormDummy> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGender;
  String? _jobStatus;
  bool _isFormFilled = false;

  void _checkFormFilled() {
    setState(() {
      _isFormFilled = _nameController.text.isNotEmpty &&
          _dobController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _selectedGender != null &&
          _jobStatus != null;
    });
  }

  void _saveProfile() {
    // dummy save action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data berhasil disimpan!")),
    );
  }

  void _logout() {
    // dummy logout action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logout berhasil!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Profile Dummy")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
                onChanged: (_) => _checkFormFilled(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: "Tanggal Lahir"),
                onChanged: (_) => _checkFormFilled(),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: const Text("Jenis Kelamin"),
                items: const ["Laki-laki", "Perempuan"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  _selectedGender = val;
                  _checkFormFilled();
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _jobStatus,
                hint: const Text("Status Pekerjaan"),
                items: const ["Pelajar", "Mahasiswa", "Karyawan", "Lainnya"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  _jobStatus = val;
                  _checkFormFilled();
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Alamat Lengkap"),
                maxLines: 3,
                onChanged: (_) => _checkFormFilled(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isFormFilled ? _saveProfile : null,
                child: const Text("Simpan Perubahan"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
