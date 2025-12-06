import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Service untuk panggil API eksternal
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      map['id'] = doc.id; 
      return map;
    }).toList();
  }

  Future<String> uploadImage(File file) async {
    final ref = _storage.ref('thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Mengembalikan ID dokumen yang baru dibuat
  Future<String> createCourseWithImage({
    required Map<String, dynamic> data,
    required File imageFile,
  }) async {
    final imageUrl = await uploadImage(imageFile);
    data['thumbnailUrl'] = imageUrl;
    data['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    
    final docRef = await _db.collection('courses').add(data);
    return docRef.id; 
  }

  // Mengembalikan ID dokumen yang baru dibuat
  Future<String> createCourseWithoutImage(Map<String, dynamic> data) async {
    data['createdAt'] = DateTime.now().millisecondsSinceEpoch;
    
    final docRef = await _db.collection('courses').add(data);
    return docRef.id; 
  }

  Future<void> updateCourse(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
    await _db.collection('courses').doc(id).update(data);
  }

  Future<void> deleteCourse(String id) async {
    await _db.collection('courses').doc(id).delete();
  }
}