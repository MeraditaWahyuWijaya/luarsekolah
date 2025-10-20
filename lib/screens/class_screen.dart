import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import '../utils/validators.dart';

enum ClassOption { edit, delete }
enum ClassCategory { populer, spl }

class KelasPopulerScreen extends StatefulWidget {
  const KelasPopulerScreen({super.key});

  @override
  State<KelasPopulerScreen> createState() => _KelasPopulerScreenState();
}

class _KelasPopulerScreenState extends State<KelasPopulerScreen> {
  static const Color _kButtonGreen = Color(0xFF00A65A);

  ClassCategory _selectedCategory = ClassCategory.populer;
  final _formKey = GlobalKey<FormBuilderState>();

  List<Map<String, dynamic>> _allClasses = [
    {
      'title': 'Teknik Pemilahan dan Pengolahan Sampah',
      'price': 'Rp 1.500.000',
      'tags': ['Prakerja', 'SPL'],
      'category': ClassCategory.spl,
      'imageAsset': 'assets/pengolahansampah.png',
    },
    {
      'title': 'Pembuatan Pestisida Ramah Lingkungan untuk Petani Terampil',
      'price': 'Rp 1.500.000',
      'tags': ['Prakerja', 'SPL'],
      'category': ClassCategory.spl,
      'imageAsset': 'assets/pestisida.jpg',
    },
    {
      'title': 'Mahir Membangun Tim Efektif dengan Metode SCRUM',
      'price': 'Rp 899.000',
      'tags': ['Profesional'],
      'category': ClassCategory.populer,
      'imageAsset': 'assets/pengolahansampah.png',
    },
  ];

  List<Map<String, dynamic>> get _filteredClasses {
    return _allClasses
        .where((kelas) => kelas['category'] == _selectedCategory)
        .toList();
  }

  void _selectCategory(ClassCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleMenuItemSelected(ClassOption result, String classTitle) {
    String action = result == ClassOption.edit ? 'Edit' : 'Delete';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action kelas: "$classTitle"')),
    );
  }

  void _showAddClassForm() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Informasi Kelas',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(thickness: 2, height: 20),
                  const SizedBox(height: 10),

                  // Nama Kelas
                  FormBuilderTextField(
                    name: 'title',
                    decoration: const InputDecoration(
                      labelText: 'Nama Kelas',
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.required('Nama Kelas'),
                  ),
                  const SizedBox(height: 16),

                  // Harga Kelas
                  FormBuilderTextField(
                    name: 'price',
                    decoration: const InputDecoration(
                      labelText: 'Harga Kelas (Rp)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga wajib diisi.';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Harga harus berupa angka.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Kategori
                  FormBuilderDropdown<ClassCategory>(
                    name: 'category',
                    decoration: const InputDecoration(
                      labelText: 'Kategori Kelas',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: ClassCategory.populer,
                   validator: (value) => Validators.requiredEnum(value, 'Kategori Kelas'),
                    items: ClassCategory.values.map((category) {
                      return DropdownMenuItem<ClassCategory>(
                        value: category,
                        child: Text(
                          category == ClassCategory.populer
                              ? 'Kelas Terpopuler'
                              : 'Kelas SPL',
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Thumbnail
                  Text(
                    'Thumbnail Kelas',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  FormBuilderImagePicker(
                    name: 'imageAsset',
                    decoration: const InputDecoration(
                      hintText: 'Pilih atau ambil gambar',
                      border: OutlineInputBorder(),
                    ),
                    maxImages: 1,
                    imageQuality: 50,
                    validator: (images) =>
                        (images == null || images.isEmpty)
                            ? 'Thumbnail wajib diisi.'
                            : null,
                  ),
                  const SizedBox(height: 24),

                  // Tombol Simpan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Kembali',
                          style: GoogleFonts.montserrat(
                              color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kButtonGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            final formData = _formKey.currentState!.value;
                            setState(() {
                              _allClasses.add({
                                'title': formData['title'],
                                'price': 'Rp ${formData['price']}',
                                'tags': ['New', 'Manual'],
                                'category': formData['category'],
                                'imageAsset':
                                    'assets/pengolahansampah.png', // placeholder
                              });
                            });
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Kelas "${formData['title']}" berhasil ditambahkan.')),
                            );
                          }
                        },
                        child: Text(
                          'Simpan',
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _selectCategory(ClassCategory.populer),
                        child: _buildCategoryTab(
                          'Kelas Terpopuler',
                          isSelected: _selectedCategory == ClassCategory.populer,
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => _selectCategory(ClassCategory.spl),
                        child: _buildCategoryTab(
                          'Kelas SPL',
                          isSelected: _selectedCategory == ClassCategory.spl,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 2, color: _kButtonGreen),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddClassForm();
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: Text(
                    'Tambah Kelas',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kButtonGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._filteredClasses.map(
              (classData) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildClassCard(
                  context,
                  title: classData['title'],
                  price: classData['price'],
                  tags: classData['tags'],
                  imageAsset: classData['imageAsset'],
                  onMenuSelected: (result) =>
                      _handleMenuItemSelected(result, classData['title']),
                ),
              ),
            ),
            if (_filteredClasses.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Tidak ada kelas di kategori yang dipilih.',
                    style: GoogleFonts.montserrat(color: Colors.grey),
                  ),
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 15),
      decoration: isSelected
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _kButtonGreen, width: 2),
              ),
            )
          : null,
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: isSelected ? Colors.black : Colors.grey.shade600,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> tags,
    required String imageAsset,
    required Function(ClassOption) onMenuSelected,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.broken_image, color: Colors.white),
                    );
                  },
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.online_prediction,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Kelas Online',
                      style: TextStyle(
                        backgroundColor: Colors.black45,
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: tags.map((tag) => _buildTag(tag)).toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuButton<ClassOption>(
          onSelected: onMenuSelected,
          itemBuilder: (BuildContext context) => <PopupMenuEntry<ClassOption>>[
            PopupMenuItem<ClassOption>(
              value: ClassOption.delete,
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete_outline,
                      color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text('Delete',
                      style: GoogleFonts.montserrat(
                          color: Colors.red.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            PopupMenuItem<ClassOption>(
              value: ClassOption.edit,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.edit_outlined, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text('Edit',
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          offset: const Offset(0, 40),
        ),
      ],
    );
  }

  Widget _buildTag(String tag) {
    bool isSPL = tag == 'SPL';
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSPL ? _kButtonGreen : Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tag,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
