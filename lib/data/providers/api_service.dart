import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Ambil kelas berdasarkan kategori
  Future<List<Map<String, dynamic>>> fetchCourses(String category) async {
    Query query = _db.collection('courses');
    if (category.toLowerCase() == 'populer') {
      query = query.where('category', isEqualTo: 'Populer');
    } else if (category.toLowerCase() == 'spl') {
      query = query.where('category', isEqualTo: 'SPL');
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final map = doc.data() as Map<String, dynamic>;
      map['id'] = doc.id; // sertakan id Firestore
      return map;
    }).toList();
  }

  // Upload image ke Firebase Storage
  Future<String> uploadImage(File file) async {
    final ref = _storage.ref('thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Tambah kelas dengan image
  Future<void> createCourseWithImage({
    required Map<String, dynamic> data,
    required File imageFile,
  }) async {
    final imageUrl = await uploadImage(imageFile);
    data['thumbnailUrl'] = imageUrl;
    data['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    await _db.collection('courses').add(data);
  }

  // Tambah kelas tanpa image
  Future<void> createCourseWithoutImage(Map<String, dynamic> data) async {
    data['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    await _db.collection('courses').add(data);
  }

  // Edit kelas
  Future<void> updateCourse(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
    await _db.collection('courses').doc(id).update(data);
  }

  // Hapus kelas
  Future<void> deleteCourse(String id) async {
    await _db.collection('courses').doc(id).delete();
  }
}
