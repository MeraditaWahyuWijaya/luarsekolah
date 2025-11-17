import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';
import 'package:luarsekolah/data/providers/firebase_auth_service.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  AuthRepository(this._firebaseAuthService);

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    await _firebaseAuthService.signUp(name, email, password);
    // Jika mau, simpan phone atau data tambahan ke Firestore di sini
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.signIn(email, password);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuthService.signOut();
  }
}
