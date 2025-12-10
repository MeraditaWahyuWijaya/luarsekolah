import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';
//Implementasi IAuthRepository
class AuthRepository implements IAuthRepository {
  final IAuthRepository _service;

//week09 disini menerima perintah drai usecase dan nerusin ke service 
//kayak nerjemahin data usecase ke service api
  AuthRepository(this._service);

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return _service.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  @override
  Future<void> login({
    required String email,
    required String password,
  }) {
    return _service.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return _service.logout();
  }
}
