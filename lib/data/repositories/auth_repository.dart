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
    // 1. Buat User di Auth
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email, password: password
    );

    // 2. LOGIKA RBAC
    String assignedRole = email.endsWith('@luarsekolah.com') ? 'admin' : 'user';

    // 3. Simpan ke Firestore (Perbaikan: role diganti assignedRole)
    UserModel newUser = UserModel(
      uid: credential.user!.uid,
      email: email,
      name: name,
      role: assignedRole, // Pakai variabel yang sudah dicek di atas
    );

    await _db.collection('users').doc(newUser.uid).set(newUser.toMap());
  }

  @override
  Future<UserEntity?> getCurrentUserData() async {
    String? uid = _auth.currentUser?.uid;
    if (uid != null) {
      var doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
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