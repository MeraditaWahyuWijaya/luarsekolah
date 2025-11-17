import 'package:firebase_auth/firebase_auth.dart';
import 'package:luarsekolah/data/providers/storage_helper.dart';

// Layanan ini mengelola semua proses otentikasi menggunakan Firebase Authentication.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream untuk memantau perubahan status otentikasi (digunakan di main.dart)
  Stream<User?> get user => _auth.authStateChanges();

  // --- REGISTRASI PENGGUNA BARU ---
  Future<UserCredential> signUp(String email, String password, String name) async {
    try {
      final cleanedEmail = email.trim();
      // 1. Membuat pengguna di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: cleanedEmail,
        password: password,
      );

      // 2. Memperbarui Display Name (Nama Pengguna)
      await userCredential.user?.updateDisplayName(name);
      
      // Catatan: Nomor telepon (phone) akan disimpan di Firestore jika diperlukan 
      // setelah proses ini selesai (di layer Business Logic/Bloc).

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah. Coba yang lebih kuat.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Akun dengan email ini sudah terdaftar.');
      }
      // Error lain dari Firebase
      throw Exception('Pendaftaran Gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi error tak terduga saat mendaftar: $e');
    }
  }

  // --- LOGIN PENGGUNA ---
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final cleanedEmail = email.trim();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: cleanedEmail,
        password: password,
      );
      
      // Jika kamu masih perlu token dari API lama untuk fetchCourses, 
      // logic untuk mendapatkan token itu harus diletakkan di sini 
      // setelah login Firebase berhasil (sangat tergantung backend lama kamu).

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw Exception('Email atau password salah. Cek kembali kredensial Anda.');
      }
      throw Exception('Login Gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi error tak terduga saat login: $e');
    }
  }

  // --- SIGN OUT ---
  Future<void> signOut() async {
    await _auth.signOut();
    // Hapus token API lama dari local storage jika ada (ini diperlukan agar fetchCourses gagal jika user logout)
    await StorageHelper.deleteAccessToken(); 
  }
}