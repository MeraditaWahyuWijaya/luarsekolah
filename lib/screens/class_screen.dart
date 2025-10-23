import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import '../utils/validators.dart';
import '../services/api_service.dart';
import 'dart:io';

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

  final ApiService _apiService = ApiService();
  bool _isFormVisible = false;
  bool _isEditMode = false;

  Map<String, dynamic>? _classToEdit;

  late Future<List<Map<String, dynamic>>> _futureClasses;
  List<Map<String, dynamic>> _fetchedClasses = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _futureClasses = _apiService.fetchClasses();
    });
  }

  List<Map<String, dynamic>> get _filteredClasses {
    return _fetchedClasses
        .where((kelas) {
          final id = int.tryParse(kelas['id'].toString()) ?? 0;
          final category = (id % 2 == 0 || kelas['categoryTag']?.contains(ClassCategory.populer.toString()) == true)
              ? ClassCategory.populer
              : ClassCategory.spl;
          return category == _selectedCategory;
        })
        .toList();
  }

  void _showEditForm(Map<String, dynamic> classData) {
    setState(() {
      _isEditMode = true;
      _isFormVisible = true;
      _classToEdit = classData;
    });
  }

  void _selectCategory(ClassCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleMenuItemSelected(
      ClassOption result, Map<String, dynamic> classData) {
    if (result == ClassOption.edit) {
      _showEditForm(classData);
    } else if (result == ClassOption.delete) {
      _deleteClass(
          classData['id'].toString(), classData['name'] ?? classData['title']);
    }
  }

  Future<void> _submitAddClass(Map<String, dynamic> formData) async {
    try {
      final List<dynamic>? selectedImages = formData['imageAsset'];
      String? imageUrl;

      if (selectedImages != null && selectedImages.isNotEmpty) {
        final selectedImage = selectedImages.first;
        if (selectedImage is File) {
          imageUrl = selectedImage.path;
        }
      }

      await _apiService.createCourse(
        formData['title'],
        formData['price'],
        formData['category'].toString(), 
        imageUrl ?? 'https://example.com/default-thumbnail.jpg',
      );

      setState(() {
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        _fetchedClasses.add({
          'id': newId,
          'name': formData['title'],
          'price': formData['price'],
          'categoryTag': [formData['category'].toString()],
          'thumbnail': imageUrl,
        });
        _isFormVisible = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kelas "${formData['title']}" berhasil ditambahkan!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah kelas: $e')),
      );
    }
  }

  Future<void> _deleteClass(String classId, String classTitle) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus kelas "$classTitle"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Hapus')),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _apiService.deleteCourse(classId);

      setState(() {
        _fetchedClasses.removeWhere((kelas) => kelas['id'].toString() == classId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kelas "$classTitle" berhasil dihapus!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus kelas: ${e.toString()}')),
      );
    }
  }

  Future<void> _submitEditClass(Map<String, dynamic> formData) async {
    if (_classToEdit == null) return;
    
    // Perbaikan: Pastikan ID diambil dengan aman sebagai String
    final String idToEdit = _classToEdit!['id']?.toString() ?? '';
    
    if (idToEdit.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengedit: ID kelas tidak ditemukan.')),
        );
        return;
    }
    
    final String? oldThumbnail = _classToEdit!['thumbnail']?.toString(); 

    try {
      await _apiService.updateCourse(
        id: idToEdit,
        name: formData['title'],
        price: formData['price'],
        category: formData['category'].toString(),
        thumbnailUrl: oldThumbnail ?? 'https://example.com/default-thumbnail.jpg',
        rating: double.tryParse(formData['rating'].toString()) ?? 4.5,
      );

      setState(() {
        final index =
            _fetchedClasses.indexWhere((kelas) => kelas['id'].toString() == idToEdit);
        if (index != -1) {
          _fetchedClasses[index] = {
            ..._fetchedClasses[index],
            'name': formData['title'],
            'price': formData['price'], 
            'categoryTag': [formData['category'].toString()],
          };
        }
        _isFormVisible = false;
        _isEditMode = false;
        _classToEdit = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kelas "${formData['title']}" berhasil diedit!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit kelas: ${e.toString()}')),
      );
    }
  }

  String _formatClassPrice(Map<String, dynamic> classData) {
    if (classData['price'] != null) {
        final price = classData['price'].toString().replaceAll('.', '').replaceAll(',', '').trim();
        if (double.tryParse(price) != null) {
            return 'Harga: Rp $price'; 
        }
    }
    
    final id = int.tryParse(classData['id'].toString()) ?? 0;
    
    if (classData['body'] is String && classData['body'].contains('Harga Kelas:')) {
        final bodyText = classData['body'] as String;
        final priceValue = bodyText.replaceFirst('Harga Kelas:', '').trim();
        return 'Harga: Rp $priceValue';
    }

    if (id <= 10 && id > 0) {
        final simulatedPrice = id * 50000;
        return 'Harga: Rp ${simulatedPrice.toString()}'; 
    }

    return 'Harga: Tidak Diketahui';
  }

  Widget _buildAddClassFormWidget() {
    final bool isEditing = _isEditMode && _classToEdit != null;

    final String initialPrice = isEditing
        ? (_classToEdit!['price']?.toString() ?? '')
            .replaceAll('Rp ', '')
            .replaceAll('.', '')
            .replaceAll(',', '')
            .trim()
        : '';
        
    final String initialTitle = isEditing
        ? _classToEdit!['name'] ?? _classToEdit!['title'] ?? ''
        : '';

    final ClassCategory initialCategory = isEditing
        ? (_classToEdit!['category'] as ClassCategory? ?? ClassCategory.populer)
        : ClassCategory.populer;
        
    final Map<String, dynamic>? initialValues = isEditing
        ? {
            'title': initialTitle,
            'price': initialPrice,
            'category': initialCategory,
          }
        : null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: FormBuilder(
        key: _formKey,
        initialValue: initialValues ?? const {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(isEditing ? 'Edit Informasi Kelas' : 'Informasi Kelas Baru',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 20)),
            const Divider(thickness: 2, height: 20),
            const SizedBox(height: 10),
            FormBuilderTextField(
              name: 'title',
              decoration: const InputDecoration(
                labelText: 'Nama Kelas',
                border: OutlineInputBorder(),
              ),
              validator: Validators.required('Nama Kelas'),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'price',
              decoration: const InputDecoration(
                labelText: 'Harga Kelas (Hanya Angka)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Harga wajib diisi.';
                if (double.tryParse(
                        value.replaceAll('.', '').replaceAll(',', '')) ==
                    null) return 'Harga harus berupa angka.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            FormBuilderDropdown<ClassCategory>(
              name: 'category',
              decoration: const InputDecoration(
                labelText: 'Kategori Kelas',
                border: OutlineInputBorder(),
              ),
              initialValue: initialCategory,
              validator: (value) =>
                  Validators.requiredEnum(value, 'Kategori Kelas'),
              items: ClassCategory.values.map((category) {
                return DropdownMenuItem<ClassCategory>(
                  value: category,
                  child: Text(category == ClassCategory.populer
                      ? 'Kelas Terpopuler'
                      : 'Kelas SPL'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (!isEditing) ...[
              Text('Thumbnail Kelas',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              FormBuilderImagePicker(
                name: 'imageAsset',
                decoration: const InputDecoration(
                  hintText: 'Pilih atau ambil gambar',
                  border: OutlineInputBorder(),
                ),
                maxImages: 1,
                imageQuality: 50,
                validator: (images) => (images == null || images.isEmpty)
                    ? 'Thumbnail wajib diisi.'
                    : null,
              ),
              const SizedBox(height: 24),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isFormVisible = false;
                      _isEditMode = false;
                      _classToEdit = null;
                    });
                  },
                  child: Text('Batal',
                      style: GoogleFonts.montserrat(color: Colors.grey.shade600)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kButtonGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final formData = _formKey.currentState!.value;
                      if (isEditing) {
                        _submitEditClass(formData);
                      } else {
                        _submitAddClass(formData);
                      }
                    }
                  },
                  child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan',
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddClassButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isFormVisible = true;
              _isEditMode = false;
              _classToEdit = null;
            });
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ],
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
                        child: _buildCategoryTab('Kelas Terpopuler',
                            isSelected:
                                _selectedCategory == ClassCategory.populer),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => _selectCategory(ClassCategory.spl),
                        child: _buildCategoryTab('Kelas SPL',
                            isSelected: _selectedCategory == ClassCategory.spl),
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
            _isFormVisible ? _buildAddClassFormWidget() : _buildAddClassButton(),
            const SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureClasses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: CircularProgressIndicator(color: _kButtonGreen),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Text(
                        'Gagal memuat data dari API: \n${snapshot.error}',
                        style: GoogleFonts.montserrat(
                            color: Colors.red, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  _fetchedClasses = snapshot.data!;

                  if (_filteredClasses.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text('Tidak ada kelas di kategori yang dipilih.',
                            style: GoogleFonts.montserrat(color: Colors.grey)),
                      ),
                    );
                  }

                  return Column(
                    children: _filteredClasses
                        .map(
                          (classData) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildClassCard(
                              context,
                              classData: classData,
                              title: classData['name'] ?? classData['title'] ?? 'Judul Tidak Tersedia',
                              price: _formatClassPrice(classData),
                              tags: const ['API', 'Prakerja'],
                              imagePath: classData['thumbnail'] ?? 'assets/pengolahansampah.png',
                              onMenuSelected: (result) =>
                                  _handleMenuItemSelected(result, classData),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }
                return const SizedBox.shrink();
              },
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
          ? const BoxDecoration(
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
    required Map<String, dynamic> classData,
    required String title,
    required String price,
    required List<String> tags,
    required String imagePath,
    required Function(ClassOption) onMenuSelected,
  }) {
    
    Widget _getImageWidget() {
      if (imagePath.startsWith('assets/') || imagePath.contains('/assets/')) {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
        );
      }
      try {
        final File imageFile = File(imagePath);
        if (imageFile.existsSync()) {
            return Image.file(
                imageFile,
                fit: BoxFit.cover,
            );
        }
      } catch (_) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.white),
      );
    }
    
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
                _getImageWidget(),
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
          onSelected: (result) => onMenuSelected(result),
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