import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // 1. Buat User di Firebase Authentication
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email, password: password
    );

    String uid = credential.user!.uid;

    // 2. LOGIKA RBAC (Role-Based Access Control)
    // Akun otomatis jadi admin jika UID-nya adalah UID baru kamu ATAU menggunakan email resmi luarsekolah
    String assignedRole = 'user';
    if (uid == 'nR3wOhJtVRkHwpoSp6Bp' || email.endsWith('@luarsekolah.com')) {
      assignedRole = 'admin';
    }

    // 3. Simpan data lengkap user ke Firestore
    UserModel newUser = UserModel(
      uid: uid,
      email: email,
      name: name,
      role: assignedRole,
    );

    await _db.collection('users').doc(newUser.uid).set(newUser.toMap());
  }

  @override
  Future<UserEntity?> getCurrentUserData() async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      // Mengambil dokumen user berdasarkan UID aktif saat ini
      var doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        // Mengonversi Map dari Firestore menjadi UserModel secara aman
        return UserModel.fromMap(doc.data()!, doc.id);
      }
    }
    return null;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async => await _auth.signOut();
}