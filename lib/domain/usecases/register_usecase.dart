import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<void> execute({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
