import 'package:luarsekolah/domain/repositories/i_auth_repository.dart';

class LoginUseCase {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  Future<void> execute({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email: email, password: password);
  }
}
