import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:io';
import 'package:get/get.dart'; 
import 'package:luarsekolah/presentation/controllers/class_controllers.dart';
import 'package:luarsekolah/domain/entities/class_model.dart';
import 'package:luarsekolah/utils/validators.dart';

class KelasPopulerScreenClean extends StatelessWidget {
  KelasPopulerScreenClean({super.key});

  static const Color _kButtonGreen = Color(0xFF00A65A);
  final _formKey = GlobalKey<FormBuilderState>();

  String _formatClassPrice(Map<String, dynamic> classData) {
    final priceValue = classData['price']?.toString() ?? '0';
    if (double.tryParse(priceValue) != null) {
      return 'Harga: Rp ${priceValue.toString().replaceAll(RegExp(r'\.0*$'), '')}';
    }
    return 'Harga: Tidak Diketahui';
  }
  
  void _handleMenuItemSelected(ClassOption result, ClassModel classData) {
    final controller = Get.find<ClassController>();
    if (result == ClassOption.edit) {
      controller.showEditForm(classData);
    } else if (result == ClassOption.delete) {
      _showDeleteConfirmationDialog(classData); 
    }
  }

  Future<void> _showDeleteConfirmationDialog(ClassModel classData) async {
    final controller = Get.find<ClassController>();
    await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus kelas "${classData.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () {
                controller.deleteClass(classData.id, classData.title);
                Get.back(result: true); 
              },
              child: const Text('Hapus')),
        ],
      ),
    );
  }

  Widget _buildAddClassFormWidget() {
    final controller = Get.find<ClassController>();
    return Obx(() {
        final bool isEditing = controller.isEditMode.value && controller.classToEdit != null;
        final ClassModel? classToEdit = controller.classToEdit;
      
        final String initialPrice = isEditing
            ? (classToEdit! .price)
                .replaceAll('Rp ', '')
                .replaceAll('.', '')
                .replaceAll(',', '')
                .trim()
            : '';
            
        final String initialTitle = isEditing
            ? classToEdit!.title 
            : '';
            
        final String initialThumbnailUrl = isEditing
            ? classToEdit!.thumbnailUrl
            : '';


        final ClassCategory initialCategory = isEditing
            ? (classToEdit!.category.toLowerCase().contains('spl') == true 
                ? ClassCategory.spl 
                : ClassCategory.populer)
            : ClassCategory.populer;
            
        final Map<String, dynamic>? initialValues = isEditing
            ? {
                        'title': initialTitle,
                        'price': initialPrice,
                        'category': initialCategory,
                        'thumbnailUrl': initialThumbnailUrl,
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
            child: SingleChildScrollView( 
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
                              null) {
                        return 'Harga harus berupa angka.';
                      }
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
                  FormBuilderTextField(
                      name: 'thumbnailUrl',
                      decoration: const InputDecoration(
                        labelText: 'URL Thumbnail Kelas',
                        hintText: 'Contoh: https://gambar.com/thumbnail.jpg',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      validator: isEditing ? null : Validators.required('URL Thumbnail'), // Hanya wajib saat mode tambah
                    ),
                    const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          controller.hideForm();
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
                              controller.submitEditClass(formData);
                            } else {
                              controller.submitAddClass(formData);
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
          ),
        );
      }
    );
  }

  Widget _buildAddClassButton() {
    final controller = Get.find<ClassController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            controller.showAddForm();
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
    required ClassModel classData,
    required String title,
    required String price,
    required List<String> tags,
    required String imagePath,
    required Function(ClassOption) onMenuSelected,
    required bool isCompleted,
    required VoidCallback onToggleComplete,
  }) {
    
    Widget getImageWidget() {
      if (imagePath.startsWith('assets/') || imagePath.contains('/assets/')) {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
        );
      }
      if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.white),
          ),
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
                getImageWidget(),
                const Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                      Icons.online_prediction,
                      color: Colors.white,
                      size: 16,
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
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
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
        Checkbox(
          value: isCompleted, 
          onChanged: (val) => onToggleComplete(),
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
    bool isSPL = tag.toUpperCase().contains('SPL');
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassController>();
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
                        onTap: () => controller.selectCategory(ClassCategory.populer),
                        child: Obx(
                          () => _buildCategoryTab('Kelas Terpopuler',
                              isSelected:
                                  controller.selectedCategory.value == ClassCategory.populer),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => controller.selectCategory(ClassCategory.spl),
                        child: Obx(
                          () => _buildCategoryTab('Kelas SPL',
                              isSelected: controller.selectedCategory.value == ClassCategory.spl),
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
            Obx(() => controller.isFormVisible.value ? _buildAddClassFormWidget() : _buildAddClassButton()),
            
            const SizedBox(height: 20),
            
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: CircularProgressIndicator(color: _kButtonGreen),
                  ),
                );
              } else if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text('Terjadi error: ${controller.errorMessage}',
                        style: GoogleFonts.montserrat(color: Colors.red)),
                  ),
                );
              }

              return Column(
                children: controller.filteredClasses
                    .map(
                      (classData) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildClassCard(
                          context,
                          classData: classData,
                          title: classData.title,
                          price: _formatClassPrice(classData.toJson()),
                          tags: [classData.category, 'API'],
                          imagePath: classData.thumbnailUrl,
                          onMenuSelected: (result) =>
                              _handleMenuItemSelected(result, classData),
                          isCompleted: classData.isCompleted,
                          onToggleComplete: () => controller.toggleCompletionStatus(classData),
                        ),
                      ),
                    )
                    .toList(),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}