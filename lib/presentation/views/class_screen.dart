import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../presentation/controllers/class_controllers.dart';
import '../../domain/entities/class_model.dart';

enum ClassOption { edit, delete }

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> with TickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<ClassController>();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        controller.selectCategory(
            _tabController.index == 0 ? ClassCategory.populer : ClassCategory.spl);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleMenuItemSelected(ClassOption option, ClassModel data) {
    final controller = Get.find<ClassController>();
    if (option == ClassOption.edit) {
      controller.showEditForm(data);
    } else if (option == ClassOption.delete) {
      _showDeleteConfirmation(data);
    }
  }

  Future<void> _showDeleteConfirmation(ClassModel data) async {
    final controller = Get.find<ClassController>();
    await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Anda yakin ingin menghapus kelas "${data.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Batal')),
          ElevatedButton(
              onPressed: () {
                controller.deleteClass(data.id);
                Get.back();
              },
              child: const Text('Hapus')),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final controller = Get.find<ClassController>();
    return Obx(() {
      final bool isEditing = controller.isEditMode.value && controller.classToEdit.value != null;
      final ClassModel? editData = controller.classToEdit.value;

      final Map<String, dynamic>? initialValues = isEditing
          ? {
              'title': editData!.title,
              'price': editData.price.toString(),
              'category': editData.category == "SPL" ? ClassCategory.spl : ClassCategory.populer,
              'thumbnailUrl': editData.thumbnailUrl,
            }
          : null;

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FormBuilder(
          key: _formKey,
          initialValue: initialValues ?? const {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Kelas' : 'Tambah Kelas',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(labelText: 'Nama Kelas', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'price',
                decoration: const InputDecoration(labelText: 'Harga', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || int.tryParse(val) == null) ? 'Harus angka' : null,
              ),
              const SizedBox(height: 12),
              FormBuilderDropdown<ClassCategory>(
                name: 'category',
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: ClassCategory.values
                    .map((c) => DropdownMenuItem(
                        value: c, child: Text(c == ClassCategory.populer ? 'Populer' : 'SPL')))
                    .toList(),
                initialValue: initialValues != null ? initialValues['category'] : ClassCategory.populer,
              ),
              const SizedBox(height: 12),
              FormBuilderTextField(
                name: 'thumbnailUrl',
                decoration: const InputDecoration(labelText: 'Thumbnail URL', border: OutlineInputBorder()),
                validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => controller.hideForm(),
                      child: Text('Batal', style: GoogleFonts.montserrat())),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final data = _formKey.currentState!.value;
                        final mapData = {
                          'title': data['title'],
                          'price': int.parse(data['price']),
                          'category': data['category'] == ClassCategory.spl ? "SPL" : "Populer",
                          'thumbnailUrl': data['thumbnailUrl'],
                        };
                        if (isEditing) {
                          controller.submitEditClass(mapData);
                        } else {
                          controller.submitAddClass(mapData);
                        }
                      }
                    },
                    child: Text(isEditing ? 'Simpan' : 'Tambah',
                        style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w500)),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildClassList() {
    final controller = Get.find<ClassController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.green));
      }
      if (controller.filteredClasses.isEmpty) {
        return Center(child: Text('Tidak ada kelas', style: GoogleFonts.montserrat(color: Colors.grey)));
      }
      return Column(
        children: controller.filteredClasses
            .map((c) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Image.network(c.thumbnailUrl, width: 60, height: 60, fit: BoxFit.cover),
                    title: Text(c.title, style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                    subtitle: Text('Harga: Rp ${c.price}'),
                    trailing: PopupMenuButton<ClassOption>(
                      onSelected: (opt) => _handleMenuItemSelected(opt, c),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: ClassOption.edit, child: Text('Edit')),
                        PopupMenuItem(value: ClassOption.delete, child: Text('Delete')),
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelas'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black54,
          labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Populer'),
            Tab(text: 'SPL'),
          ],
        ),
      ),
body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      Obx(() => Get.find<ClassController>().isFormVisible.value ? _buildForm() : const SizedBox()),
      const SizedBox(height: 12),
      _buildClassList(),
    ],
  ),
),
floatingActionButton: FloatingActionButton.extended(
  onPressed: () => Get.find<ClassController>().showAddForm(), // tombol menampilkan form
  backgroundColor: Colors.green,
  icon: const Icon(Icons.add, color: Colors.white),
  label: Text('Tambah Kelas', style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w500)),
),

    );
  }
}
