abstract class IAuthRepository {
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
