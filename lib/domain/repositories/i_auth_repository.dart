abstract class IAuthRepository {
  //ini menjaga biar logika domain tidak terikat hanya pada satu implemen data spesifik
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
