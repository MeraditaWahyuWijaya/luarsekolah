import 'package:firebase_auth/firebase_auth.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart';
import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';
//Auth via Firebase
class FirebaseAuthService implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;


//week09 ini file yang berinteraksi, mengirimkan permintaan api  langsung sama firebase auth
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

      final credential = await _auth.createUserWithEmailAndPassword( //ngirim data ke FB
        email: cleanedEmail,
        password: password,
      );
      //jika berhasil, firebase nanti membuat user dan ngembaliin berupa usercredential dibawah ini
      await credential.user?.updateDisplayName(name);
      // Phone bisa disimpan ke Firestore jika perlu

    } on FirebaseAuthException catch (e) { //melempar error kalo firebase gagal 
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
}
