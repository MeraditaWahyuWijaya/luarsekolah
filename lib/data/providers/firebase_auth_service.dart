import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart';
import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';
import 'package:luarsekolah/domain/entities/user_entity.dart';
import 'package:luarsekolah/data/models/user_model.dart';

class FirebaseAuthService implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final cleanedEmail = email.trim();

      // 1. Register ke Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: cleanedEmail,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      // 2. LOGIKA RBAC: Tentukan role berdasarkan email
      String assignedRole = cleanedEmail.endsWith('@luarsekolah.com') ? 'admin' : 'user';

      // 3. Simpan data tambahan (Role) ke Firestore
      await _db.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': cleanedEmail,
        'phone': phone,
        'role': assignedRole,
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email sudah digunakan.');
      }
      if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah.');
      }
      if (e.code == 'invalid-email') {
        throw Exception('Format email tidak valid.');
      }
      throw Exception(e.message ?? 'Terjadi kesalahan saat register.');
    }
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('Format email tidak valid.');
      }
      if (e.code == 'user-not-found') {
        throw Exception('Pengguna tidak ditemukan.');
      }
      if (e.code == 'wrong-password') {
        throw Exception('Password salah.');
      }
      throw Exception(e.message ?? 'Terjadi kesalahan saat login.');
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await StorageHelper.deleteAccessToken();
  }

  // TAMBAHKAN FUNGSI INI AGAR ERROR DI BINDING & CONTROLLER HILANG
  @override
  Future<UserEntity?> getCurrentUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final doc = await _db.collection('users').doc(currentUser.uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!, doc.id);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}